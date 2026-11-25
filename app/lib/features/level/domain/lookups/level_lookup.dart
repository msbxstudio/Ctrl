/// Defines the supported criteria for retrieving a level.
sealed class const LevelLookup() {}

/// Selects a level by its unique identifier.
final class LevelById extends LevelLookup {
  /// Creates a lookup targeting the level identified by [id].
  const new(
    this.id,
  );

  /// The identifier of the level to retrieve.
  final int id;
}
