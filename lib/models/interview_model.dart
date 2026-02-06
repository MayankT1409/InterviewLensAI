

class InterviewModel {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String createdBy;
  final DateTime createdAt;

  InterviewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory InterviewModel.fromMap(Map<String, dynamic> map, String id) {
    return InterviewModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      difficulty: map['difficulty'] ?? 'Medium',
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
