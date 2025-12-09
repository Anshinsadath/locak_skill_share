// lib/features/home/ui/home_feed.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with Firestore stream later
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Requests')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text('Help Request #$index'),
              subtitle: const Text('Short description and distance'),
              trailing: ElevatedButton(
                onPressed: () {
                  // go to chat (or request detail)
                  GoRouter.of(context).go('/chat');
                },
                child: const Text('Claim'),
              ),
              onTap: () {
                // in future open request detail
              },
            ),
          );
        },
      ),
    );
  }
}
