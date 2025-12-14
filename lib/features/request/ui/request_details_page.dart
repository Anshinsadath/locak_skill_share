import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/help_request.dart';
import '../../../core/services/request_service.dart';
import '../../../core/services/chat_service.dart';
import '../../auth/state/user_provider.dart';

class RequestDetailsPage extends ConsumerWidget {
  final HelpRequest request;

  const RequestDetailsPage({super.key, required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider).value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    final requestService = ref.read(requestServiceProvider);
    final chatService = ref.read(chatServiceProvider);

    final isOwner = user.uid == request.userId;
    final isAccepted = request.status == 'accepted';

    return Scaffold(
      appBar: AppBar(title: Text(request.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.description),
            const SizedBox(height: 10),
            Text("Price: ${request.price}"),
            const SizedBox(height: 20),

            // ---------------- ACCEPT REQUEST ----------------
            if (!isOwner && !isAccepted)
              ElevatedButton(
                onPressed: () async {
                  await requestService.acceptRequest(
                    requestId: request.id,
                    helperId: user.uid,
                  );

                  final chatId = await chatService.createOrGetChat(
                    request.userId, // owner
                    user.uid,        // helper
                  );

                  // ✅ FIXED ROUTE
                  context.go('/chat?chatId=$chatId');
                },
                child: const Text("Accept Request"),
              ),

            // ---------------- OPEN CHAT ----------------
            if (isAccepted)
              ElevatedButton(
                onPressed: () async {
                  final otherUserId =
                      user.uid == request.userId
                          ? request.acceptedBy!
                          : request.userId;

                  final chatId = await chatService.createOrGetChat(
                    user.uid,
                    otherUserId,
                  );

                  // ✅ FIXED ROUTE
                  context.go('/chat?chatId=$chatId');
                },
                child: const Text("Open Chat"),
              ),
          ],
        ),
      ),
    );
  }
}
