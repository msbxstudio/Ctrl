import 'package:flutter/foundation.dart';

import 'package:ctrl/features/level.dart';

/// Defines the retrieval contract for levels.
///
/// Provides access to individual levels, the level collection,
/// and the player's current position within the game progression.
@immutable
abstract interface class LevelRepository {
  /// Retrieves all available levels.
  Future<List<Level>> getAll();

  /// Retrieves a level matching the specified [lookup] criteria.
  Future<Level> getOne(LevelLookup lookup);

  /// Retrieves the current level within the player's progression.
  ///
  /// Returns `null` if no current level is available.
  Future<Level?> getCurrent();

  /// Returns the total number of available levels.
  Future<int> count();
}
