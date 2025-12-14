import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --------------------------------------------------
  // Create or get chat between two users
  // --------------------------------------------------
  Future<String> createOrGetChat(String user1, String user2) async {
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
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  // --------------------------------------------------
  // Get user chats
  // --------------------------------------------------
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  // --------------------------------------------------
  // Get messages
  // --------------------------------------------------
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // --------------------------------------------------
  // Send message
  // --------------------------------------------------
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
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
