class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int totalWords;
  final int streak;
  final int points;
  final List<String> achievements;
  final double dailyProgress; // 0.0 to 1.0

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.totalWords,
    required this.streak,
    required this.points,
    required this.achievements,
    required this.dailyProgress,
  });
}

class LeaderboardUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final int points;
  final int rank;

  LeaderboardUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.points,
    required this.rank,
  });
}
