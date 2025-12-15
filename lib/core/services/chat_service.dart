import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createOrGetChat(
  String user1,
  String user2, {
  String? requestId,
  String? requestTitle,
}) async {
  final users = [user1, user2]..sort();

  final existing = await _db
      .collection('chats')
      .where('participants', isEqualTo: users)
      .limit(1)
      .get();

  if (existing.docs.isNotEmpty) {
    return existing.docs.first.id;
  }

  final doc = await _db.collection('chats').add({
    'participants': users,
    'requestId': requestId,
    'requestTitle': requestTitle,
    'lastMessage': '',
    'updatedAt': FieldValue.serverTimestamp(),
    'createdAt': FieldValue.serverTimestamp(),
  });

  return doc.id;
}


  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  Future<void> sendMessage({
  required String chatId,
  required String senderId,
  required String text,
}) async {
  final chatRef = _db.collection('chats').doc(chatId);

  await chatRef.collection('messages').add({
    'senderId': senderId,
    'text': text,
    'createdAt': FieldValue.serverTimestamp(),
  });

  await chatRef.update({
    'lastMessage': text,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

}
