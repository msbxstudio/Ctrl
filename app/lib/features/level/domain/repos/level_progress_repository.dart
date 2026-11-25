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
  /// Returns the newly created progress record.
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

  /// Returns the average elapsed time across level progress records.
  Future<int> averageTime();
}
