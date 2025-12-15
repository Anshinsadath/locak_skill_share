import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/services/chat_service.dart';
import '../../auth/state/user_provider.dart';


class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider).value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.read(chatServiceProvider).getUserChats(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data();
              final chatId = chats[index].id;

              final requestTitle = chat['requestTitle'] ?? 'Request';
              final lastMessage = chat['lastMessage'] ?? '';
              final updatedAt = chat['updatedAt'] as Timestamp?;

              return ListTile(
                title: Text(requestTitle),
                subtitle: Text(
                  lastMessage.isEmpty ? 'Open chat' : lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: updatedAt != null
                    ? Text(
                        _formatTime(updatedAt),
                        style: const TextStyle(fontSize: 12),
                      )
                    : null,
                onTap: () {
                  context.go('/chat?chatId=$chatId');
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(Timestamp ts) {
    final date = ts.toDate();
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
