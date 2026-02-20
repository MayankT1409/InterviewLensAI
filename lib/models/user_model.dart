class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String role; // 'candidate' or 'interviewer'
  final DateTime createdAt;
  final String? photoUrl;
  final String? bio;
  final String? phoneNumber;
  final List<String>? skills;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
    required this.createdAt,
    this.photoUrl,
    this.bio,
    this.phoneNumber,
    this.skills,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'photoUrl': photoUrl,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'skills': skills,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      role: map['role'] ?? 'candidate',
      createdAt: DateTime.parse(map['createdAt']),
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      phoneNumber: map['phoneNumber'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : null,
    );
  }
}
