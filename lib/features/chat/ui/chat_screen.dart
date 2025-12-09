// lib/features/chat/ui/chat_screen.dart
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String? chatId;
  const ChatScreen({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat ${chatId ?? ''}')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                ListTile(title: Text("User: Hi")),
                ListTile(title: Text("You: Hello")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Expanded(child: TextField()),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
