/// Defines the supported criteria for retrieving level progress records.
sealed class const LevelProgressLookup() {}

/// Selects a progress record by its unique identifier.
final class LevelProgressById extends LevelProgressLookup {
  /// Creates a lookup targeting the progress record identified by [id].
  const new(
    this.id,
  );

  /// The identifier of the progress record to retrieve.
  final int id;
}

/// Selects progress records associated with a specific level.
final class LevelProgressByLevelId extends LevelProgressLookup {
  /// Creates a lookup targeting progress associated with [levelId].
  const new(
    this.levelId,
  );

  /// The identifier of the level whose progress is to be retrieved.
  final int levelId;
}
