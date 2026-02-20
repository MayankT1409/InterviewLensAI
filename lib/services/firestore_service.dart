import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../models/interview_model.dart';
import '../models/interview_request_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createInterview(InterviewModel interview) async {
    await _db.collection('interviews').doc(interview.id).set(interview.toMap());
  }

  // --- Interview Request Methods ---

  Future<void> createInterviewRequest(InterviewRequestModel request) async {
    await _db.collection('interview_requests').doc(request.id).set(request.toMap());
  }

  Stream<List<InterviewRequestModel>> getPendingRequests() {
    return _db.collection('interview_requests')
        .where('status', isEqualTo: 'pending')
        // .orderBy('createdAt', descending: true) // Removed: Index issue
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InterviewRequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<InterviewRequestModel>> getCandidateRequests(String candidateId) {
    return _db.collection('interview_requests')
        .where('candidateId', isEqualTo: candidateId)
        // .orderBy('createdAt', descending: true) // Removed: Index issue
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InterviewRequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<InterviewRequestModel>> getAcceptedRequests(String interviewerId) {
    return _db.collection('interview_requests')
        .where('interviewerId', isEqualTo: interviewerId)
        .where('status', isEqualTo: 'accepted')
        // .orderBy('createdAt', descending: true) // Removed: Index issue
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InterviewRequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<InterviewRequestModel>> getCompletedRequests(String interviewerId) {
    return _db.collection('interview_requests')
        .where('interviewerId', isEqualTo: interviewerId)
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InterviewRequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateRequestStatus(String requestId, String status, {String? interviewerId, String? interviewerName}) async {
    Map<String, dynamic> data = {'status': status};
    if (interviewerId != null) data['interviewerId'] = interviewerId;
    if (interviewerName != null) data['interviewerName'] = interviewerName;
    
    await _db.collection('interview_requests').doc(requestId).update(data);
  }

  Future<void> saveUser(UserModel user) async {
    // Save to role-specific collection
    String collection = 'users'; // fallback
    if (user.role == 'candidate') collection = 'candidates';
    if (user.role == 'interviewer') collection = 'interviewers';
    
    await _db.collection(collection).doc(user.uid).set(user.toMap()).timeout(const Duration(seconds: 10));
  }

  Future<void> saveInterviewFeedback(Map<String, dynamic> feedback, String userId) async {
     await _db.collection('interviews').add({
       ...feedback,
       'userId': userId,
       'createdAt': DateTime.now().toIso8601String(),
     });
  }

  Stream<List<Map<String, dynamic>>> getUserHistory(String userId) {
    return _db.collection('interviews')
        .where('userId', isEqualTo: userId)
        // .orderBy('createdAt', descending: true) // Avoid index issues for now
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      // 1. Try Candidates
      DocumentSnapshot doc = await _db.collection('candidates').doc(uid).get();
      if (doc.exists) return UserModel.fromMap(doc.data() as Map<String, dynamic>);

      // 2. Try Interviewers
      doc = await _db.collection('interviewers').doc(uid).get();
      if (doc.exists) return UserModel.fromMap(doc.data() as Map<String, dynamic>);

      // 3. Try legacy 'users'
      doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) return UserModel.fromMap(doc.data() as Map<String, dynamic>);

      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
  
  Future<void> updateUser(UserModel user) async {
    String collection = 'users';
    if (user.role == 'candidate') collection = 'candidates';
    if (user.role == 'interviewer') collection = 'interviewers';
    
    await _db.collection(collection).doc(user.uid).update(user.toMap());
  }

  Future<String> uploadProfileImage(File image, String userId) async {
     try {
       // Create a reference to the location you want to upload to in firebase
       final storageRef = FirebaseStorage.instance.ref().child('user_profiles/$userId.jpg');

       // Upload the file to the path "user_profiles/$userId.jpg"
       await storageRef.putFile(image);

       // Get the download URL
       final downloadUrl = await storageRef.getDownloadURL();
       return downloadUrl;
     } catch (e) {
       print('Error uploading image: $e');
       rethrow;
     }
  }
}
