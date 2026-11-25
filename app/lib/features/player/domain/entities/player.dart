///
final class Player {
  ///
  const new({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.lastActiveAt,
    required this.streakDays,
  });

  factory defaults() {
    return Player(
      id: 1,
      name: 'Player',
      createdAt: DateTime.now(),
      updatedAt: null,
      lastActiveAt: null,
      streakDays: 0,
    );
  }

  ///
  final int id;

  ///
  final DateTime createdAt;

  ///
  final DateTime? updatedAt;

  ///
  final DateTime? lastActiveAt;

  ///
  final String name;

  ///
  final int streakDays;
}
