import 'package:go_router/go_router.dart';
import '../features/auth/ui/login_page.dart';
import '../features/home/ui/home_page.dart';
import '../features/payment/payment_screen.dart'; // ✅ import your payment screen

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/payment', builder: (context, state) => const PaymentTestScreen()), // ✅ payment route
  ],
);
