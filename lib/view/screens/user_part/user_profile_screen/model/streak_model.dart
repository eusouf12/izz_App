class StreakResponse {
  bool? success;
  String? message;
  List<StreakData>? data;

  StreakResponse({
    this.success,
    this.message,
    this.data,
  });

  factory StreakResponse.fromJson(Map<String, dynamic> json) {
    return StreakResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<StreakData>.from(
        json['data'].map((x) => StreakData.fromJson(x)),
      )
          : [],
    );
  }
}

class StreakData {
  String? id;
  String? streakType;
  int? currentStreak;
  int? bestStreak;
  String? lastActiveDate;
  int? bonusXP;
  String? createdAt;
  String? updatedAt;
  String? userId;

  StreakData({
    this.id,
    this.streakType,
    this.currentStreak,
    this.bestStreak,
    this.lastActiveDate,
    this.bonusXP,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      id: json['id'],
      streakType: json['streakType'],
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastActiveDate: json['lastActiveDate'],
      bonusXP: json['bonusXP'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
    );
  }
}

