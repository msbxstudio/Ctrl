import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:msbx/contracts.dart';

/// Manages the application's local SQLite database.
///
/// Provides singleton access, database initialization, migrations,
/// initial data seeding, and resource disposal.
///
/// Supports concurrent initialization, idempotent disposal,
/// and recreation after disposal.
final class DatabaseService implements Disposable {
  /// Creates a database service with deferred initialization.
  new _();

  /// Name of the application's SQLite database file.
  static const String _databaseName = 'ctrl.db';

  static DatabaseService? _instance;

  Database? _database;

  Future<void>? _initialization;
  Future<void>? _disposal;

  bool _initialized = false;
  bool _disposed = false;

  /// Whether the database has been initialized successfully.
  bool get isInitialized => _initialized && !_disposed;

  /// Whether disposal has been requested.
  @override
  bool get isDisposed => _disposed;

  /// Returns the initialized singleton instance.
  ///
  /// Throws a [StateError] if the service has not been initialized
  /// or has been disposed.
  static DatabaseService get instance {
    final instance = _instance;

    if (instance == null || !instance.isInitialized) {
      throw StateError('Database service is not initialized.');
    }

    return instance;
  }

  /// Returns the initialized SQLite database.
  ///
  /// Throws a [StateError] if the service has not been initialized
  /// or has been disposed.
  Database get service {
    if (_disposed) {
      throw StateError('Database service has been disposed.');
    }

    if (!_initialized) {
      throw StateError('Database service has not been initialized.');
    }

    return _database!;
  }

  /// Initializes the singleton database service.
  ///
  /// Concurrent calls share the same initialization operation.
  /// Waits for pending disposal before creating a new instance.
  ///
  /// Failed initialization releases acquired resources.
  static Future<void> initialize() {
    final current = _instance;

    if (current != null) {
      if (current._disposed) {
        return current.dispose().then((_) => initialize());
      }

      return current._initialization ?? Future<void>.value();
    }

    final instance = DatabaseService._();
    _instance = instance;

    return instance._initialization = instance._initialize();
  }

  Future<void> _initialize() async {
    Database? database;

    try {
      database = await _openDatabase();

      if (_disposed) {
        throw StateError(
          'Database service was disposed during initialization.',
        );
      }

      await _seedDatabase(database);

      if (_disposed) {
        throw StateError(
          'Database service was disposed during initialization.',
        );
      }

      _database = database;
      _initialized = true;
    } catch (_) {
      _initialized = false;
      _disposed = true;

      if (database != null) {
        try {
          await database.close();
        } catch (_) {
          // Preserve the original initialization error.
        }
      }

      if (identical(_instance, this)) {
        _instance = null;
      }

      rethrow;
    }
  }

  /// Returns the path to the application's SQLite database.
  static Future<String> _getDatabasePath() async {
    final directory = await getDatabasesPath();
    return join(directory, _databaseName);
  }

  /// Opens the SQLite database and configures its schema.
  ///
  /// Creates the database if necessary and applies registered
  /// migrations when upgrading from an older version.
  static Future<Database> _openDatabase() async {
    final path = await _getDatabasePath();

    return openDatabase(
      path,
      version: _DatabaseMigration.version,
      onCreate: _DatabaseMigration.onCreate,
      onUpgrade: _DatabaseMigration.onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }

  /// Seeds the database with initial levels and player data.
  ///
  /// Existing records are preserved. All insertions are performed
  /// within a single transaction.
  ///
  /// Throws if the asset cannot be loaded, decoded, or inserted.
  static Future<void> _seedDatabase(Database database) async {
    final jsonString = await rootBundle.loadString('assets/data/levels.json');
    final jsonData = jsonDecode(jsonString) as List;

    await database.transaction((txn) async {
      for (final data in jsonData) {
        await txn.insert('levels', <String, dynamic>{
          ...data,
          'question': jsonEncode(data['question']),
          'options': jsonEncode(data['options']),
          'hint': data['hint'] != null ? jsonEncode(data['hint']) : null,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      await txn.insert('players', {
        'id': 1,
        'name': 'Player',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    });
  }

  /// Disposes the service and releases its database connection.
  ///
  /// Waits for pending initialization before closing the database.
  /// Concurrent calls share the same disposal operation.
  ///
  /// A disposed instance cannot be initialized again.
  @override
  Future<void> dispose() {
    return _disposal ??= _dispose();
  }

  Future<void> _dispose() async {
    _disposed = true;
    _initialized = false;

    try {
      await _initialization;
    } catch (_) {
      // Initialization failures already release acquired resources.
    }

    final database = _database;
    _database = null;

    try {
      await database?.close();
    } finally {
      if (identical(_instance, this)) {
        _instance = null;
      }
    }
  }

  /// Queries rows from the specified [table].
  ///
  /// Supports column selection, filtering, grouping, ordering,
  /// and pagination.
  ///
  /// Returns a list of column-value maps.
  ///
  /// Throws a [StateError] if the service is not initialized
  /// or has been disposed.
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
    return service.query(
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

  /// Inserts [values] into the specified [table].
  ///
  /// Returns the inserted row ID or the result defined by
  /// the selected [conflictAlgorithm].
  ///
  /// Throws a [StateError] if the service is not initialized
  /// or has been disposed.
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    return service.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Updates rows in the specified [table] with [values].
  ///
  /// Returns the number of affected rows.
  /// Omitting [where] may update every row.
  ///
  /// Throws a [StateError] if the service is not initialized
  /// or has been disposed.
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    return service.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  /// Deletes rows from the specified [table].
  ///
  /// Returns the number of deleted rows.
  /// Omitting [where] may delete every row.
  ///
  /// Throws a [StateError] if the service is not initialized
  /// or has been disposed.
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) {
    return service.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Resets the local database to its initial state.
  ///
  /// Closes the current connection, deletes the database file,
  /// and recreates the database with its default schema and seed data.
  ///
  /// Preserves the service instance and its lifecycle state.
  ///
  /// Permanently removes all locally stored data.
  ///
  /// Must not run concurrently with other database operations,
  /// initialization, disposal, or another reset.
  Future<void> reset() async {
    if (!isInitialized) {
      throw StateError('Database service is not initialized.');
    }

    final database = _database!;

    _initialized = false;
    _database = null;

    await database.close();

    final path = await _getDatabasePath();
    await deleteDatabase(path);

    final newDatabase = await _openDatabase();

    try {
      await _seedDatabase(newDatabase);

      _database = newDatabase;
      _initialized = true;
    } catch (_) {
      await newDatabase.close();
      rethrow;
    }
  }
}

/// Defines the SQLite database schema and its versioned migrations.
///
/// Creates the current application tables and upgrades older schemas
/// while preserving existing data.
final class _DatabaseMigration {
  /// Current database schema version.
  static const int version = 2;

  /// Creates the current database schema for new installations.
  ///
  /// Defines the levels, level progresses, and players tables with their
  /// corresponding constraints and relationships.
  static Future<void> onCreate(Database db, int version) async {
    // 1. Table: levels
    await db.execute('''
      CREATE TABLE IF NOT EXISTS levels (
        id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        type TEXT NOT NULL,
        keyboard TEXT NOT NULL,
        question TEXT NOT NULL DEFAULT '{}',
        answer TEXT NOT NULL,
        hint TEXT NULL,
        options TEXT NOT NULL DEFAULT '[]'
      );
    ''');

    // 2. Table: level_progresses
    await db.execute('''
      CREATE TABLE IF NOT EXISTS level_progresses (
        id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        attempts INTEGER NOT NULL DEFAULT 0,
        time_ms INTEGER NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        level_id INTEGER NOT NULL,

        FOREIGN KEY(level_id)
          REFERENCES levels(id)
          ON DELETE CASCADE
      );
    ''');

    // 3. Table: players
    await db.execute('''
      CREATE TABLE IF NOT EXISTS players (
        id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT NULL,
        last_active_at TEXT NULL,
        name TEXT NOT NULL,
        streak_days INTEGER NOT NULL DEFAULT 0,
        current_level_id INTEGER NOT NULL DEFAULT 1,

        FOREIGN KEY(current_level_id)
          REFERENCES levels(id)
      );
    ''');
  }

  /// Applies schema changes when upgrading the database.
  ///
  /// Receives the previous [oldVersion] and target [newVersion].
  ///
  /// Version 2 pluralizes table names without recreating their records.
  /// sqflite runs this callback inside a transaction.
  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute('ALTER TABLE level RENAME TO levels');
      await db.execute('ALTER TABLE level_progress RENAME TO level_progresses');
      await db.execute('ALTER TABLE player RENAME TO players');
    }
  }
}
