// lib/features/chat/ui/chat_list.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with Firestore chat list stream later
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          final chatId = 'chat_$index';
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('Conversation with User #$index'),
            subtitle: const Text('Last message preview...'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // navigate to chat screen with optional param
              // We'll use a simple route /chat?chatId=chat_1
              GoRouter.of(context).go('/chat?chatId=$chatId');
            },
          );
        },
      ),
    );
  }
}
