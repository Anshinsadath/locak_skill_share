// lib/features/common/bottom_nav_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/ui/home_feed.dart';
import '../chat/ui/chat_list.dart';
import '../profile/ui/profile_page.dart';
import '../request/ui/post_request_page.dart'; // <-- FIXED import (one level up)

class BottomNavScreen extends ConsumerStatefulWidget {
  const BottomNavScreen({super.key});

  @override
  ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeFeed(),
    const ChatList(),
    // placeholder for center (we'll open Post via FAB)
    const SizedBox.shrink(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      // center index (2) is reserved for FAB -> ignore taps
      if (index == 2) return;
      _selectedIndex = index > 2 ? index - 1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).go('/post'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // left side
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    ),
                    onPressed: () => _onItemTapped(0),
                    tooltip: 'Home',
                  ),
                  IconButton(
                    icon: Icon(
                      _selectedIndex == 1 ? Icons.chat : Icons.chat_bubble_outline,
                    ),
                    onPressed: () => _onItemTapped(1),
                    tooltip: 'Chats',
                  ),
                ],
              ),

              // right side
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _selectedIndex == 2 ? Icons.person : Icons.person_outline,
                    ),
                    onPressed: () => _onItemTapped(3),
                    tooltip: 'Profile',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
