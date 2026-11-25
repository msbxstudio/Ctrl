import 'package:flutter/foundation.dart';

import 'package:ctrl/features/level.dart';

/// Defines the retrieval contract for game levels.
///
/// Provides access to the level collection, individual levels, and
/// progression-related information.
@immutable
abstract interface class LevelRepository {
  /// Retrieves the complete collection of available levels.
  Future<List<Level>> getAll();

  /// Retrieves the level identified by the specified [lookup] criteria.
  Future<Level> getOne(LevelLookup lookup);

  /// Retrieves the level associated with the player's current progression.
  ///
  /// Returns `null` when no current level is available.
  Future<Level?> getCurrent();

  /// Returns the total number of available levels.
  Future<int> getCount([
    LevelCountFilter filter = LevelCountFilter.all,
  ]);
}
