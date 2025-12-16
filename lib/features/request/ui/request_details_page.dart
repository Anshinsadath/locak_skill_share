import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/help_request.dart';
import '../../../core/services/request_service.dart';
import '../../../core/services/chat_service.dart';
import '../../auth/state/user_provider.dart';
import '../../../core/widgets/gradient_button.dart';


class RequestDetailsPage extends ConsumerWidget {
  final HelpRequest request;

  const RequestDetailsPage({
    super.key,
    required this.request,
  });

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
    final isHelper = request.acceptedBy == user.uid;

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

            // --------------------------------------------------
            // ACCEPT REQUEST (USER B)
            // --------------------------------------------------
            if (!isOwner && !isAccepted)
              GradientButton(
  text: "Accept Request",
  icon: Icons.check_circle,
  onPressed: () async {
    await requestService.acceptRequest(
      requestId: request.id,
      helperId: user.uid,
    );

    final chatId = await chatService.createOrGetChat(
      request.userId,
      user.uid,
    );

    context.go('/chat?chatId=$chatId');
  },
),


            // --------------------------------------------------
            // OPEN CHAT (OWNER OR HELPER)
            // --------------------------------------------------
            if (isAccepted && (isOwner || isHelper))
             GradientButton(
  text: "Open Chat",
  icon: Icons.chat,
  onPressed: () async {
    final otherUserId =
        isOwner ? request.acceptedBy! : request.userId;

    final chatId = await chatService.createOrGetChat(
      user.uid,
      otherUserId,
    );

    // context.go('/chat?chatId=$chatId');
    context.push('/chat?chatId=$chatId');

  },
),

          ],
        ),
      ),
    );
  }
}
