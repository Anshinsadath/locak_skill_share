import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pages
import '../home/ui/home_page.dart';
import '../chat/ui/chat_list.dart';
import '../request/ui/my_requests_page.dart';
import '../request/ui/accepted_requests_page.dart';
import '../profile/ui/profile_page.dart';
import '../../core/widgets/gradient_fab.dart';


class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ChatListPage(),
    MyRequestsPage(),
    AcceptedRequestsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: GradientFAB(
  icon: Icons.add,
  onPressed: () => context.go('/post'),
),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Accepted'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
