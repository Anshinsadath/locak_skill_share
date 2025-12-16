import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/chat_service.dart';
import '../../auth/state/user_provider.dart';
import '../../../core/widgets/gradient_app_bar.dart';


class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseUserProvider).value;
    final chatService = ref.read(chatServiceProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
//       appBar: AppBar(
//   leading: IconButton(
//     icon: const Icon(Icons.arrow_back),
//     onPressed: () {
//       Navigator.of(context).pop(); // ✅ SAFE
//     },
//   ),
//   title: StreamBuilder<DocumentSnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) return const Text("Chat");
//       final data = snapshot.data!.data() as Map<String, dynamic>;
//       return Text(data['requestTitle'] ?? 'Chat');
//     },
//   ),
// ),

      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(70),
  child: StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .snapshots(),
    builder: (context, snapshot) {
      final title = snapshot.hasData
          ? (snapshot.data!.data() as Map<String, dynamic>)['requestTitle'] ?? 'Chat'
          : 'Chat';

      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E6F40),
              Color(0xFF68BA7F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),

      body: Column(
        children: [
          // ---------------- MESSAGES ----------------
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data();
                    final isMe = data['senderId'] == user.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.25),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft:
                                Radius.circular(isMe ? 16 : 0),
                            bottomRight:
                                Radius.circular(isMe ? 0 : 16),
                          ),
                        ),
                        child: Text(
                          data['text'] ?? '',
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onBackground,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ---------------- INPUT ----------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      final text = _messageController.text.trim();
                      if (text.isEmpty) return;

                      await chatService.sendMessage(
                        chatId: widget.chatId,
                        senderId: user.uid,
                        text: text,
                      );

                      _messageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
