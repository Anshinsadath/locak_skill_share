import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/help_request.dart';

class RequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createRequest(HelpRequest request) async {
    await _db.collection('requests').add(request.toMap());
  }

  Stream<List<HelpRequest>> getRequests() {
    return _db
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HelpRequest.fromDoc(doc)).toList());
  }
}
