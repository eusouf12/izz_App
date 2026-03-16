class AboutAppResponseModel {
  final bool? success;
  final String? message;
  final AboutAppData? data;

  AboutAppResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory AboutAppResponseModel.fromJson(Map<String, dynamic> json) {
    return AboutAppResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? AboutAppData.fromJson(json['data'])
          : null,
    );
  }
}

class AboutAppData {
  final String? id;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  AboutAppData({
    this.id,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutAppData.fromJson(Map<String, dynamic> json) {
    return AboutAppData(
      id: json['id'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
