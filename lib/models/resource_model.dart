class ResourceModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  ResourceModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // Factory constructor to efficiently map from raw JSON payload
  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  // Method to safely serialize back to JSON if needed for local preservation
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
