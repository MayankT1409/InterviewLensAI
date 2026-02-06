class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String role; // 'candidate' or 'interviewer'
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      role: map['role'] ?? 'candidate',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
