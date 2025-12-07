import 'package:go_router/go_router.dart';
import '../features/auth/ui/login_page.dart';
import '../features/home/ui/home_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ],
);
