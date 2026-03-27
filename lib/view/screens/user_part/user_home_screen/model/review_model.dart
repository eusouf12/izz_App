class ReviewResponse {
  bool? success;
  String? message;
  ReviewMeta? meta;
  List<ReviewData>? data;

  ReviewResponse({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? ReviewMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<ReviewData>.from(
              json['data'].map((x) => ReviewData.fromJson(x)),
            )
          : [],
    );
  }
}

class ReviewMeta {
  int? total;
  int? page;
  int? limit;

  ReviewMeta({
    this.total,
    this.page,
    this.limit,
  });

  factory ReviewMeta.fromJson(Map<String, dynamic> json) {
    return ReviewMeta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}

class ReviewData {
  String? id;
  double? rating;
  dynamic subRatings;
  String? comment;
  String? createdAt;
  String? updatedAt;

  String? userId;
  String? venueId;
  String? venueBookingId;

  ReviewUser? user;

  ReviewData({
    this.id,
    this.rating,
    this.subRatings,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.venueId,
    this.venueBookingId,
    this.user,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'],
      rating: (json['rating'] ?? 0).toDouble(),
      subRatings: json['subRatings'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      venueId: json['venueId'],
      venueBookingId: json['venueBookingId'],
      user: json['user'] != null
          ? ReviewUser.fromJson(json['user'])
          : null,
    );
  }
}

class ReviewUser {
  String? id;
  String? fullName;
  String? email;
  String? contactNumber;
  String? profileImage;

  ReviewUser({
    this.id,
    this.fullName,
    this.email,
    this.contactNumber,
    this.profileImage,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      profileImage: json['profileImage'],
    );
  }
}