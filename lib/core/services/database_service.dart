import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'app_service.dart';

final class DatabaseService extends AppService<Database> {
  static final instance = DatabaseService._();

  DatabaseService._() : super.later();

  @override
  void initialize() async {
    if (isInitialized) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ctrl.db');

    service = await openDatabase(
      path,
      version: _DatabaseMigration.version,
      onCreate: _DatabaseMigration.onCreate,
      onUpgrade: _DatabaseMigration.onUpgrade,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );

    setInitialized(true);
  }

  @override
  void dispose() async {
    await service.close();
    setInitialized(false);
  }

  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return service.database.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    return service.database.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    return service.database.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) {
    return service.database.delete(table, where: where, whereArgs: whereArgs);
  }
}

final class _DatabaseMigration {
  static const version = 1;

  static Future<void> onCreate(Database db, int version) async {
    // 1. Table: level
    await db.execute('''
      CREATE TABLE IF NOT EXISTS level (
        id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        type TEXT NOT NULL,
        keyboard TEXT NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        options TEXT NOT NULL DEFAULT '[]'
      );
    ''');

    // 2. Table: level_progress
    await db.execute('''
      CREATE TABLE IF NOT EXISTS level_progress (
        id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        time_ms INTEGER NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        level_id INTEGER NOT NULL,

        FOREIGN KEY(level_id)
          REFERENCES level(id)
          ON DELETE CASCADE
      );
    ''');

    // 3. Table: player
    await db.execute('''
      CREATE TABLE IF NOT EXISTS player (
        id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NULL,
        last_active_at TEXT NULL,
        name TEXT NOT NULL,
        streak_days INTEGER NOT NULL DEFAULT 0,
        current_level_id INTEGER NOT NULL DEFAULT 1,

        FOREIGN KEY(current_level_id)
          REFERENCES level(id)
      );
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // MVP: no migrations yet
  }
}
