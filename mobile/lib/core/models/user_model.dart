class UserModel {
  final int id;
  final String email;
  final String name;
  final bool isPremium;
  final String subscriptionType;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.isPremium,
    required this.subscriptionType,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isPremium: json['is_premium'] ?? false,
      subscriptionType: json['subscription_type'] ?? 'free',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'is_premium': isPremium,
      'subscription_type': subscriptionType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}


