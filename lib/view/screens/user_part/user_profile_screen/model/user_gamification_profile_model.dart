class UserGamificationProfileModel {
  bool success;
  String message;
  GamificationData data;

  UserGamificationProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserGamificationProfileModel.fromJson(Map<String, dynamic> json) {
    return UserGamificationProfileModel(
      success: json['success'],
      message: json['message'],
      data: GamificationData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class GamificationData {
  String id;
  int currentLevel;
  int currentXP;
  int totalXP;
  int atlasPoints;
  int streakDays;
  DateTime lastActiveDate;
  int bookingCount;
  int reviewCount;
  int referralCount;
  int challengeCount;
  int nextLevelXP;
  String levelTitle;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;
  User user;
  List<Badge> badges;
  List<Achievement> achievements;
  List<Streak> streaks;
  int totalLevels;

  GamificationData({
    required this.id,
    required this.currentLevel,
    required this.currentXP,
    required this.totalXP,
    required this.atlasPoints,
    required this.streakDays,
    required this.lastActiveDate,
    required this.bookingCount,
    required this.reviewCount,
    required this.referralCount,
    required this.challengeCount,
    required this.nextLevelXP,
    required this.levelTitle,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.user,
    required this.badges,
    required this.achievements,
    required this.streaks,
    required this.totalLevels,
  });

  factory GamificationData.fromJson(Map<String, dynamic> json) {
    return GamificationData(
      id: json['id'],
      currentLevel: json['currentLevel'],
      currentXP: json['currentXP'],
      totalXP: json['totalXP'],
      atlasPoints: json['atlasPoints'],
      streakDays: json['streakDays'],
      lastActiveDate: DateTime.parse(json['lastActiveDate']),
      bookingCount: json['bookingCount'],
      reviewCount: json['reviewCount'],
      referralCount: json['referralCount'],
      challengeCount: json['challengeCount'],
      nextLevelXP: json['nextLevelXP'],
      levelTitle: json['levelTitle'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
      user: User.fromJson(json['user']),
      badges: List<Badge>.from(json['badges'].map((x) => Badge.fromJson(x))),
      achievements: List<Achievement>.from(
          json['achievements'].map((x) => Achievement.fromJson(x))),
      streaks:
      List<Streak>.from(json['streaks'].map((x) => Streak.fromJson(x))),
      totalLevels: json['totalLevels'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentLevel': currentLevel,
      'currentXP': currentXP,
      'totalXP': totalXP,
      'atlasPoints': atlasPoints,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate.toIso8601String(),
      'bookingCount': bookingCount,
      'reviewCount': reviewCount,
      'referralCount': referralCount,
      'challengeCount': challengeCount,
      'nextLevelXP': nextLevelXP,
      'levelTitle': levelTitle,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'user': user.toJson(),
      'badges': badges.map((x) => x.toJson()).toList(),
      'achievements': achievements.map((x) => x.toJson()).toList(),
      'streaks': streaks.map((x) => x.toJson()).toList(),
      'totalLevels': totalLevels,
    };
  }
}

class User {
  String fullName;
  String email;
  String profileImage;

  User({
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

class Badge {
  String id;
  String name;
  String description;
  String iconUrl;
  int xpReward;
  int pointsReward;
  DateTime earnedAt;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.xpReward,
    required this.pointsReward,
    required this.earnedAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconUrl: json['iconUrl'],
      xpReward: json['xpReward'],
      pointsReward: json['pointsReward'],
      earnedAt: DateTime.parse(json['earnedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'xpReward': xpReward,
      'pointsReward': pointsReward,
      'earnedAt': earnedAt.toIso8601String(),
    };
  }
}

class Achievement {
  String id;
  String name;
  String description;
  int progress;
  int targetValue;
  bool isCompleted;
  int xpReward;
  int pointsReward;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.targetValue,
    required this.isCompleted,
    required this.xpReward,
    required this.pointsReward,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      progress: json['progress'],
      targetValue: json['targetValue'],
      isCompleted: json['isCompleted'],
      xpReward: json['xpReward'],
      pointsReward: json['pointsReward'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'progress': progress,
      'targetValue': targetValue,
      'isCompleted': isCompleted,
      'xpReward': xpReward,
      'pointsReward': pointsReward,
    };
  }
}

class Streak {
  String id;
  String streakType;
  int currentStreak;
  int bestStreak;
  DateTime lastActiveDate;
  int bonusXP;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;

  Streak({
    required this.id,
    required this.streakType,
    required this.currentStreak,
    required this.bestStreak,
    required this.lastActiveDate,
    required this.bonusXP,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      id: json['id'],
      streakType: json['streakType'],
      currentStreak: json['currentStreak'],
      bestStreak: json['bestStreak'],
      lastActiveDate: DateTime.parse(json['lastActiveDate']),
      bonusXP: json['bonusXP'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'streakType': streakType,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastActiveDate': lastActiveDate.toIso8601String(),
      'bonusXP': bonusXP,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }
}
