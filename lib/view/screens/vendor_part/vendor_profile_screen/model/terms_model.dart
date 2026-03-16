class TermsResponseModel {
  final bool? success;
  final String? message;
  final List<TermsData>? data;

  TermsResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory TermsResponseModel.fromJson(Map<String, dynamic> json) {
    return TermsResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<TermsData>.from(
        json['data'].map((x) => TermsData.fromJson(x)),
      )
          : [],
    );
  }
}

class TermsData {
  final String? id;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  TermsData({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      id: json['id'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
