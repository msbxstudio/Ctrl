import 'package:flutter/foundation.dart';

import 'package:ctrl/features/level.dart';

/// Defines the persistence contract for level progress records.
///
/// Provides operations for retrieving, creating, and updating progress,
/// as well as computing aggregate completion metrics.
@immutable
abstract interface class LevelProgressRepository {
  /// Retrieves a progress record matching the specified [lookup] criteria.
  Future<LevelProgress> getOne(LevelProgressLookup lookup);

  /// Creates a progress record associated with [levelId].
  ///
  /// Records the initial number of [attempts] and [ellapsedTime].
  ///
  /// Returns the persisted progress with its database ID. If progress already
  /// exists for this level, returns it without resetting the player's data.
  Future<LevelProgress> create({
    required int levelId,
    required int attempts,
    required int ellapsedTime,
  });

  /// Updates the progress record identified by [id].
  ///
  /// Allows partial updates to the number of [attempts], [ellapsedTime],
  /// and completion status through [isCompleted].
  ///
  /// Returns the updated progress record.
  Future<LevelProgress> update(
    int id, {
    int? attempts,
    int? ellapsedTime,
    bool? isCompleted,
  });

  /// Returns the rounded average completion time in milliseconds.
  ///
  /// Excludes incomplete levels and records without a time. Returns zero
  /// when no completed levels have a recorded time.
  Future<int> averageTime();
}
