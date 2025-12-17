class ProgressModel {
  final int totalMinutes;
  final int totalSessions;
  final int currentStreak;
  final int longestStreak;

  ProgressModel({
    required this.totalMinutes,
    required this.totalSessions,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      totalMinutes: json['total_minutes'] ?? 0,
      totalSessions: json['total_sessions'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
    );
  }

  String get formattedTime {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}ч ${mins}м';
    }
    return '${mins}м';
  }
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int progress;
  final int maxProgress;
  final DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.maxProgress,
    this.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      progress: json['progress'] ?? 0,
      maxProgress: json['max_progress'] ?? 1,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'])
          : null,
    );
  }

  bool get isUnlocked => progress >= maxProgress;

  double get progressPercent => progress / maxProgress;
}


