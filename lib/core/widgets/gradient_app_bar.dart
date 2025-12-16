import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      elevation: 0,
      title: Text(title),
      actions: actions,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primary,   // #2E6F40
              AppTheme.secondary, // #68BA7F
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
