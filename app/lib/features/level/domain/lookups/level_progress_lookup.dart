sealed class const LevelProgressLookup() {}

final class LevelProgressById extends LevelProgressLookup {
  const new(this.id);

  final int id;
}

final class LevelProgressByLevelId extends LevelProgressLookup {
  const new(this.levelId);

  final int levelId;
}
