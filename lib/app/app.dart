import 'package:flutter/material.dart';
import 'router.dart';

class LocalSkillShareApp extends StatelessWidget {
  const LocalSkillShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Local Skill Share',
      routerConfig: appRouter,
    );
  }
}
