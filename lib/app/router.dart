import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth State Providers
import '../features/auth/state/user_provider.dart';

// Auth Pages
import '../features/auth/ui/login_page.dart';
import '../features/auth/ui/register_page.dart';

// Main App Screens
import '../features/common/bottom_nav_screen.dart';
import '../features/request/ui/post_request_page.dart';
import '../features/chat/ui/chat_screen.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,

  // ---------------- REDIRECT LOGIC ----------------
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final authState = container.read(firebaseUserProvider).value;

    // Current path string: "/login", "/home", etc.
    final currentPath = state.uri.toString();

    final loggingIn =
        currentPath == '/login' ||
        currentPath == '/register';

    // If NOT LOGGED IN → force to /login
    if (authState == null) {
      return loggingIn ? null : '/login';
    }

    // If LOGGED IN → prevent access to login/register
    if (loggingIn) return '/home';

    return null;
  },

  // ---------------- ROUTES ----------------
  routes: [
    // AUTH ROUTES
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
    ),

    // MAIN APP (Bottom Navigation)
    GoRoute(
      path: '/home',
      builder: (_, __) => const BottomNavScreen(),
    ),

    // POST REQUEST PAGE (FAB)
    GoRoute(
      path: '/post',
      builder: (_, __) => const PostRequestPage(),
    ),

    // CHAT PAGE (supports query params like ?chatId=chat_1)
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final chatId = state.uri.queryParameters['chatId'];
        return ChatScreen(chatId: chatId);
      },
    ),
  ],
);
