class PrivacyPolicyModel {
  String? id;
  String? description;

  PrivacyPolicyModel({this.id, this.description});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    description = json['description'];
  }
}