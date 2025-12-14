import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/chat_service.dart';
import '../../auth/state/user_provider.dart';

final chatServiceProvider = Provider((ref) => ChatService());

// Chat list for this user
final userChatsProvider = StreamProvider((ref) {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) return const Stream.empty();

  return ref.watch(chatServiceProvider).getUserChats(user.uid);
});

// Messages for a specific chat
final chatMessagesProvider =
    StreamProvider.family((ref, String chatId) {
  return ref.watch(chatServiceProvider).getMessages(chatId);
});
