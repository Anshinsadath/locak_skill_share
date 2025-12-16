import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/state/user_provider.dart';
import '../features/auth/ui/login_page.dart';
import '../features/auth/ui/register_page.dart';
import '../features/common/bottom_nav_screen.dart';
import '../features/request/ui/post_request_page.dart';
import '../features/request/ui/request_details_page.dart';
import '../features/request/ui/edit_request_page.dart';
import '../features/chat/ui/chat_list.dart';
import '../features/chat/ui/chat_screen.dart';
import '../models/help_request.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,

  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final authState = container.read(firebaseUserProvider).value;

    final path = state.uri.path;
    final isAuthPage = path == '/login' || path == '/register';

    if (authState == null) {
      return isAuthPage ? null : '/login';
    }

    if (isAuthPage) return '/home';
    return null;
  },

  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
    GoRoute(path: '/home', builder: (_, __) => const BottomNavScreen()),
    GoRoute(path: '/post', builder: (_, __) => const PostRequestPage()),

    // ✅ CHAT ROUTE (FIXED)
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final chatId = state.uri.queryParameters['chatId'];
        if (chatId == null) {
          return const ChatListPage();
        }
        return ChatScreen(chatId: chatId);
      },
    ),
//     GoRoute(
//   path: '/chat',
//   builder: (context, state) {
//     final chatId = state.uri.queryParameters['chatId']!;
//     return ChatScreen(chatId: chatId);
//   },
// ),


    GoRoute(
      path: '/request-details',
      builder: (context, state) {
        final req = state.extra;
        if (req == null || req is! HelpRequest) {
          throw Exception('HelpRequest required');
        }
        return RequestDetailsPage(request: req);
      },
    ),

    GoRoute(
      path: '/edit-request',
      builder: (context, state) {
        final req = state.extra;
        if (req == null || req is! HelpRequest) {
          throw Exception('HelpRequest required');
        }
        return EditRequestPage(request: req);
      },
    ),
  ],
);
