int calculateStreak(int currentStreak, DateTime? lastActiveAt) {
  if (lastActiveAt == null) {
    return 1;
  }

  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final lastDay = DateTime(
    lastActiveAt.year,
    lastActiveAt.month,
    lastActiveAt.day,
  );

  final daysDifference = today.difference(lastDay).inDays;

  if (daysDifference == 0) {
    // Already active today, return current streak
    return currentStreak;
  }

  if (daysDifference == 1) {
    // Streak continues, increment by 1
    return currentStreak + 1;
  }

  // Streak broken, reset to 1
  return 1;
}
