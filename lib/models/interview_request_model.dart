import 'package:cloud_firestore/cloud_firestore.dart';

class InterviewRequestModel {
  final String id;
  final String candidateId;
  final String candidateName;
  final String status; // 'pending', 'accepted', 'rejected', 'completed'
  final String? interviewerId;
  final String? interviewerName;
  final DateTime createdAt;
  final DateTime? scheduledAt;

  InterviewRequestModel({
    required this.id,
    required this.candidateId,
    required this.candidateName,
    required this.status,
    required this.createdAt,
    this.interviewerId,
    this.interviewerName,
    this.scheduledAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'candidateId': candidateId,
      'candidateName': candidateName,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'interviewerId': interviewerId,
      'interviewerName': interviewerName,
      'scheduledAt': scheduledAt != null ? Timestamp.fromDate(scheduledAt!) : null,
    };
  }

  factory InterviewRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return InterviewRequestModel(
      id: docId,
      candidateId: map['candidateId'] ?? '',
      candidateName: map['candidateName'] ?? 'Unknown',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      interviewerId: map['interviewerId'],
      interviewerName: map['interviewerName'],
      scheduledAt: map['scheduledAt'] != null ? (map['scheduledAt'] as Timestamp).toDate() : null,
    );
  }
}
