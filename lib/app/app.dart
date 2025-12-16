import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class LocalSkillShareApp extends StatelessWidget {
  const LocalSkillShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Local Skill Share',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
