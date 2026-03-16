class VendorTremsAndConditions {
  String? id;
  String? description; // Change this key based on your API response (e.g., 'content', 'text')

  VendorTremsAndConditions({this.id, this.description});

  VendorTremsAndConditions.fromJson(Map<String, dynamic> json) {
    id = json['_id']; // Adjust based on your API
    description = json['description']; // Adjust based on your API
  }
}
