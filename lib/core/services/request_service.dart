import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/help_request.dart';

final requestServiceProvider = Provider<RequestService>((ref) {
  return RequestService();
});

class RequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createRequest(HelpRequest request) async {
    await _db.collection('requests').add(request.toMap());
  }

  Stream<List<HelpRequest>> getAllRequests() {
    return _db
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => HelpRequest.fromMap(d.data(), d.id)).toList(),
        );
  }

  Stream<List<HelpRequest>> getUserRequests(String uid) {
    return _db
        .collection('requests')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => HelpRequest.fromMap(d.data(), d.id)).toList(),
        );
  }

  Future<void> updateRequest(String id, Map<String, dynamic> data) async {
    await _db.collection('requests').doc(id).update(data);
  }

  Future<void> deleteRequest(String id) async {
    await _db.collection('requests').doc(id).delete();
  }

  // ✅ FIXED: NAMED PARAMETERS
  Future<void> acceptRequest({
    required String requestId,
    required String helperId,
  }) async {
    await _db.collection('requests').doc(requestId).update({
      'status': 'accepted',
      'acceptedBy': helperId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeRequest(String requestId) async {
    await _db.collection('requests').doc(requestId).update({
      'status': 'completed',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
