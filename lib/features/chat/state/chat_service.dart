import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService();
});

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --------------------------------------------------------------
  // 1️⃣ Create or Get Chat ID for two users
  // --------------------------------------------------------------
  Future<String> createOrGetChat(String userA, String userB) async {
    // Look for existing chat with both users
    final chats = await _db
        .collection('chats')
        .where('participants', arrayContains: userA)
        .get();

    for (var c in chats.docs) {
      List participants = c['participants'];
      if (participants.contains(userB)) {
        return c.id; // Chat already exists
      }
    }

    // Create new chat
    final newChat = await _db.collection('chats').add({
      'participants': [userA, userB], // Consistent field name
      'lastMessage': '',
      'updatedAt': Timestamp.now(),
    });

    return newChat.id;
  }

  // --------------------------------------------------------------
  // 2️⃣ Send message
  // --------------------------------------------------------------
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final msgRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.now(),
    });

    // Update chat header
    await _db.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'updatedAt': Timestamp.now(),
    });
  }

  // --------------------------------------------------------------
  // 3️⃣ Stream messages in real-time
  // --------------------------------------------------------------
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  // --------------------------------------------------------------
  // 4️⃣ Stream chat list of current user
  // --------------------------------------------------------------
  Stream<List<Map<String, dynamic>>> getUserChats(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid) // updated field name
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {...doc.data(), "id": doc.id}).toList());
  }
}
