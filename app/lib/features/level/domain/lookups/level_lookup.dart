sealed class const LevelLookup() {}

final class LevelById extends LevelLookup {
  const new(this.id);

  final int id;
}
