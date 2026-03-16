// =======================
// Sports Type Response Model
// =======================
class SportsTypeResponseModel {
  bool? success;
  String? message;
  SportsTypeDataWrapper? data;

  SportsTypeResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory SportsTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return SportsTypeResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? SportsTypeDataWrapper.fromJson(json['data'])
          : null,
    );
  }
}

// =======================
// Data Wrapper (Meta + List)
// =======================
class SportsTypeDataWrapper {
  Meta? meta;
  List<SportsType>? data;

  SportsTypeDataWrapper({
    this.meta,
    this.data,
  });

  factory SportsTypeDataWrapper.fromJson(Map<String, dynamic> json) {
    return SportsTypeDataWrapper(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<SportsType>.from(
        json['data'].map((x) => SportsType.fromJson(x)),
      )
          : [],
    );
  }
}

// =======================
// Meta Model
// =======================
class Meta {
  int? total;
  int? page;
  int? limit;

  Meta({
    this.total,
    this.page,
    this.limit,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}

// =======================
// Sports Type Item Model
// =======================
class SportsType {
  String? id;
  String? sportName;
  String? sportsImage;
  String? createdAt;
  String? updatedAt;

  SportsType({
    this.id,
    this.sportName,
    this.sportsImage,
    this.createdAt,
    this.updatedAt,
  });

  factory SportsType.fromJson(Map<String, dynamic> json) {
    return SportsType(
      id: json['id'],
      sportName: json['sportName'],
      sportsImage: json['sportsImage'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
