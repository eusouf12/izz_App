class LevelResponse {
  bool? success;
  String? message;
  List<LevelData>? data;

  LevelResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LevelResponse.fromJson(Map<String, dynamic> json) {
    return LevelResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<LevelData>.from(
        json['data'].map((x) => LevelData.fromJson(x)),
      )
          : [],
    );
  }
}

class LevelData {
  String? id;
  int? level;
  String? title;
  int? minXP;
  int? maxXP;
  List<String>? benefits;
  String? badgeReward;
  String? createdAt;
  String? updatedAt;

  LevelData({
    this.id,
    this.level,
    this.title,
    this.minXP,
    this.maxXP,
    this.benefits,
    this.badgeReward,
    this.createdAt,
    this.updatedAt,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      id: json['id'],
      level: json['level'] ?? 0,
      title: json['title'],
      minXP: json['minXP'] ?? 0,
      maxXP: json['maxXP'] ?? 0,
      benefits: json['benefits'] != null
          ? List<String>.from(json['benefits'])
          : [],
      badgeReward: json['badgeReward'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}