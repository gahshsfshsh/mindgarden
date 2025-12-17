class ContentModel {
  final int id;
  final String type;
  final String title;
  final String? description;
  final String? duration;
  final String? category;
  final String? level;
  final bool isPremium;
  final String? audioUrl;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? instructor;

  ContentModel({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.duration,
    this.category,
    this.level,
    required this.isPremium,
    this.audioUrl,
    this.videoUrl,
    this.thumbnailUrl,
    this.instructor,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      category: json['category'],
      level: json['level'],
      isPremium: json['is_premium'] ?? false,
      audioUrl: json['audio_url'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      instructor: json['instructor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'duration': duration,
      'category': category,
      'level': level,
      'is_premium': isPremium,
      'audio_url': audioUrl,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'instructor': instructor,
    };
  }

  String get levelDisplay {
    switch (level) {
      case 'beginner':
        return '🌱 Начинающий';
      case 'intermediate':
        return '⭐ Средний';
      case 'advanced':
        return '🔥 Продвинутый';
      default:
        return '';
    }
  }

  String get typeDisplay {
    switch (type) {
      case 'meditation':
        return 'Медитация';
      case 'yoga':
        return 'Йога';
      case 'sleep':
        return 'Сон';
      default:
        return type;
    }
  }
}


