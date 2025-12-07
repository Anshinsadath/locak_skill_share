import 'package:flutter/material.dart';
import 'router.dart';

class LocalSkillShareApp extends StatelessWidget {
  const LocalSkillShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Local Skill Share',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
