import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:msbx/exceptions.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/features/level.dart';

LevelProgressRepository repository() => LevelProgressRepositoryImpl(
  LocalLevelProgressDataSourceImpl(DatabaseService.instance),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;
  DatabaseService? service;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('ctrl_progress_');
    await databaseFactory.setDatabasesPath(directory.path);
  });

  tearDown(() async {
    await service?.dispose();
    service = null;
    await directory.delete(recursive: true);
  });

  Future<void> initialize() async {
    await DatabaseService.initialize();
    service = DatabaseService.instance;
  }

  group('level progress persistence', () {
    setUp(initialize);

    test('average time is zero when no completed levels have a time', () async {
      expect(await repository().averageTime(), 0);
      await repository().create(levelId: 1, attempts: 0, ellapsedTime: 9000);
      expect(await repository().averageTime(), 0);
      await service!.insert('level_progresses', {
        'level_id': 2,
        'is_completed': 1,
        'time_ms': null,
      });
      expect(await repository().averageTime(), 0);
    });

    test(
      'average uses completed times, ignores NULL, and rounds milliseconds',
      () async {
        for (final entry in {1: 1000, 2: 2001}.entries) {
          final created = await repository().create(
            levelId: entry.key,
            attempts: 1,
            ellapsedTime: entry.value,
          );
          await repository().update(created.id, isCompleted: true);
        }
        await service!.insert('level_progresses', {
          'level_id': 3,
          'is_completed': 1,
          'time_ms': null,
        });
        await repository().create(
          levelId: 4,
          attempts: 0,
          ellapsedTime: 900000,
        );
        final pending = await repository().create(
          levelId: 5,
          attempts: 0,
          ellapsedTime: 0,
        );
        expect(await repository().averageTime(), 1501);

        // Zero is a valid recorded duration once a level has been completed.
        await repository().update(pending.id, isCompleted: true);
        expect(await repository().averageTime(), 1000);
      },
    );

    test(
      'creates with a real ID and preserves partial updates after reopening',
      () async {
        final created = await repository().create(
          levelId: 1,
          attempts: 0,
          ellapsedTime: 0,
        );
        expect(created.id, greaterThan(0));
        final persisted = await repository().getOne(LevelProgressByLevelId(1));
        expect(persisted.id, created.id);

        await repository().update(created.id, attempts: 1);
        final updated = await repository().update(
          created.id,
          ellapsedTime: 2500,
          isCompleted: true,
        );
        expect(updated.attempts, 1);
        expect(updated.createdAt, created.createdAt);

        await service!.dispose();
        await initialize();

        final reopened = await repository().getOne(LevelProgressByLevelId(1));
        expect(reopened.id, created.id);
        expect(reopened.attempts, 1);
        expect(reopened.ellapsedTime, 2500);
        expect(reopened.completed, isTrue);
        expect(reopened.createdAt, created.createdAt);
      },
    );

    test(
      'concurrent creation keeps one record and preserves existing progress',
      () async {
        final results = await Future.wait([
          for (var i = 0; i < 5; i++)
            repository().create(levelId: 1, attempts: 0, ellapsedTime: 0),
        ]);
        final id = results.first.id;
        expect(results.map((progress) => progress.id).toSet(), {id});
        await repository().update(
          id,
          attempts: 3,
          ellapsedTime: 1500,
          isCompleted: true,
        );

        final existing = await repository().create(
          levelId: 1,
          attempts: 0,
          ellapsedTime: 0,
        );
        expect(existing.id, id);
        expect(existing.attempts, 3);
        expect(existing.ellapsedTime, 1500);
        expect(existing.completed, isTrue);
        expect(await service!.query('level_progresses'), hasLength(1));
      },
    );

    test(
      'updates to missing records fail instead of reporting success',
      () async {
        await expectLater(
          repository().update(999, attempts: 1),
          throwsA(isA<NotFoundException>()),
        );
        final local = LocalLevelProgressDataSourceImpl(service!);
        await expectLater(
          local.save(
            LevelProgressModel(
              id: 999,
              createdAt: DateTime.now(),
              attempts: 1,
              ellapsedTime: 0,
              completed: false,
              levelId: 1,
              level: null,
            ),
          ),
          throwsA(isA<NotFoundException>()),
        );
        expect(await service!.query('level_progresses'), isEmpty);
      },
    );

    test('failed inserts do not return fictitious progress', () async {
      await expectLater(
        repository().create(levelId: -1, attempts: 0, ellapsedTime: 0),
        throwsA(isA<UnknownException>()),
      );
      expect(await service!.query('level_progresses'), isEmpty);
    });

    test(
      'enter, answer, and reenter a level using the real controller',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final provider = levelControllerProvider(1);
        container.listen(provider, (_, _) {});
        container.listen(checkAnswerMutationProvider, (_, _) {});

        final initial = await container.read(provider.future);
        expect(initial.progress.id, greaterThan(0));
        final controller = container.read(provider.notifier);
        expect(await controller.checkAnswer('incorrect'), isFalse);
        expect(container.read(checkAnswerMutationProvider).hasError, isFalse);
        var persisted = await repository().getOne(LevelProgressByLevelId(1));
        expect(persisted.attempts, 1);
        expect(persisted.completed, isFalse);

        expect(await controller.checkAnswer(initial.level.answer), isTrue);
        expect(container.read(checkAnswerMutationProvider).hasError, isFalse);
        persisted = await repository().getOne(LevelProgressByLevelId(1));
        expect(persisted.attempts, 2);
        expect(persisted.completed, isTrue);
        expect(persisted.ellapsedTime, isNonNegative);
        final levels = LocalLevelDataSourceImpl(service!);
        expect(await levels.countCompleted(), 1);
        expect((await levels.findCurrent())!.id, 2);

        await controller.refresh();
        final reopened = await container.read(provider.future);
        expect(reopened.progress.id, initial.progress.id);
        expect(reopened.progress.completed, isTrue);
        expect(await controller.checkAnswer(initial.level.answer), isTrue);
        persisted = await repository().getOne(LevelProgressByLevelId(1));
        expect(persisted.attempts, 2);
        expect(await service!.query('level_progresses'), hasLength(1));
      },
    );

    test(
      'refresh preserves the session start and the full completion time',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final provider = levelControllerProvider(1);
        container.listen(provider, (_, _) {});
        container.listen(checkAnswerMutationProvider, (_, _) {});

        final initial = await container.read(provider.future);
        final controller = container.read(provider.notifier);
        await controller.checkAnswer('incorrect');
        for (var i = 0; i < 2; i++) {
          await controller.refresh();
          final refreshed = await container.read(provider.future);
          expect(refreshed.startTime, initial.startTime);
          expect(refreshed.progress.attempts, 1);
        }

        final beforeAnswer = DateTime.now();
        expect(await controller.checkAnswer(initial.level.answer), isTrue);
        final afterAnswer = DateTime.now();
        final completed = await repository().getOne(LevelProgressByLevelId(1));
        expect(
          completed.ellapsedTime,
          inInclusiveRange(
            beforeAnswer.difference(initial.startTime).inMilliseconds,
            afterAnswer.difference(initial.startTime).inMilliseconds,
          ),
        );
        expect(await repository().averageTime(), completed.ellapsedTime);
        await controller.refresh();
        expect(
          (await container.read(provider.future)).progress.ellapsedTime,
          completed.ellapsedTime,
        );
      },
    );

    test(
      'each level and each new controller has its own session start',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final provider = levelControllerProvider(1);
        final subscription = container.listen(provider, (_, _) {});
        final initial = await container.read(provider.future);
        final controller = container.read(provider.notifier);

        final nextProvider = levelControllerProvider(2);
        container.listen(nextProvider, (_, _) {});
        final next = await container.read(nextProvider.future);
        expect(next.startTime.isAfter(initial.startTime), isTrue);

        subscription.close();
        await container.pump();
        container.listen(provider, (_, _) {});
        final reentered = await container.read(provider.future);
        expect(container.read(provider.notifier), isNot(same(controller)));
        expect(reentered.startTime.isAfter(initial.startTime), isTrue);
        expect(reentered.progress.id, initial.progress.id);
      },
    );
  });

  test(
    'migrates published version 1 to RC version 2 without data loss',
    () async {
      await createPublishedDatabase(path.join(directory.path, 'ctrl.db'));
      await initialize();
      final db = service!.service;
      expect(await db.getVersion(), 2);
      final levelColumns = await db.rawQuery('PRAGMA table_info(levels)');
      expect(
        levelColumns.map((column) => column['name']),
        contains('sort_order'),
      );
      final playerColumns = await db.rawQuery('PRAGMA table_info(players)');
      expect(
        playerColumns.map((column) => column['name']),
        isNot(contains('current_level_id')),
      );
      expect(await db.rawQuery('PRAGMA foreign_key_check'), isEmpty);
      final player = (await db.query('players')).single;
      expect(player['name'], 'Existing player');
      expect(player['streak_days'], 7);
      expect(player['last_active_at'], '2026-11-24T12:00:00');
      final progress = await repository().getOne(LevelProgressByLevelId(1));
      expect(progress.id, 42);
      expect(progress.attempts, 4);
      expect(progress.ellapsedTime, 2300);
      expect(progress.completed, isTrue);
      expect(progress.createdAt, DateTime(2026, 11, 20));
      final levels = LocalLevelDataSourceImpl(service!);
      expect(await levels.countCompleted(), 1);
      expect((await levels.findCurrent())!.id, 2);

      final created = await repository().create(
        levelId: 2,
        attempts: 0,
        ellapsedTime: 0,
      );
      await repository().update(created.id, attempts: 1, isCompleted: true);
      final existing = await repository().create(
        levelId: 2,
        attempts: 0,
        ellapsedTime: 0,
      );
      expect(existing.id, created.id);
      expect(existing.attempts, 1);
      expect(existing.completed, isTrue);
      expect(await db.query('level_progresses'), hasLength(2));

      await service!.dispose();
      await initialize();
      expect((await repository().getOne(LevelProgressByLevelId(1))).id, 42);
      expect(await service!.service.getVersion(), 2);
    },
  );

  test(
    'creates and reopens RC version 2 without applying the migration',
    () async {
      await initialize();
      expect(await service!.service.getVersion(), 2);
      final created = await repository().create(
        levelId: 1,
        attempts: 2,
        ellapsedTime: 1500,
      );

      await service!.dispose();
      await initialize();

      expect(await service!.service.getVersion(), 2);
      final persisted = await repository().getOne(LevelProgressByLevelId(1));
      expect(persisted.id, created.id);
      expect(persisted.attempts, 2);
      expect(persisted.ellapsedTime, 1500);
      expect(
        await service!.service.rawQuery('PRAGMA foreign_key_check'),
        isEmpty,
      );
    },
  );
}

/// Reproduces the version 1 schema used by the published application.
Future<void> createPublishedDatabase(String databasePath) async {
  final db = await openDatabase(
    databasePath,
    version: 1,
    onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE level (
          id INTEGER PRIMARY KEY,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          type TEXT NOT NULL,
          keyboard TEXT NOT NULL,
          question TEXT NOT NULL DEFAULT '{}',
          answer TEXT NOT NULL,
          hint TEXT NULL,
          options TEXT NOT NULL DEFAULT '[]'
        )
      ''');
      await db.execute('''
        CREATE TABLE level_progress (
          id INTEGER PRIMARY KEY,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          attempts INTEGER NOT NULL DEFAULT 0,
          time_ms INTEGER NULL,
          is_completed INTEGER NOT NULL DEFAULT 0,
          level_id INTEGER NOT NULL,
          FOREIGN KEY(level_id) REFERENCES level(id) ON DELETE CASCADE
        )
      ''');
      await db.execute('''
        CREATE TABLE player (
          id INTEGER PRIMARY KEY,
          created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT NULL,
          last_active_at TEXT NULL,
          name TEXT NOT NULL,
          streak_days INTEGER NOT NULL DEFAULT 0,
          current_level_id INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY(current_level_id) REFERENCES level(id)
        )
      ''');
    },
  );
  try {
    await db.insert('level', {
      'id': 1,
      'type': 'syntax',
      'keyboard': 'symbol',
      'answer': ')',
    });
    await db.insert('level_progress', {
      'id': 42,
      'created_at': '2026-11-20T00:00:00',
      'attempts': 4,
      'time_ms': 2300,
      'is_completed': 1,
      'level_id': 1,
    });
    await db.insert('player', {
      'id': 1,
      'name': 'Existing player',
      'streak_days': 7,
      'last_active_at': '2026-11-24T12:00:00',
    });
  } finally {
    await db.close();
  }
}
