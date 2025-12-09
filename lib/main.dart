import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app/app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load environment variables
  await dotenv.load(fileName: ".env");

  // ✅ Initialize Stripe (Publishable Key ONLY)
  Stripe.publishableKey = dotenv.env['pk_test_51Sblaj7qWNcy8fXQP0SJyibBWpDdkjlyPzPfZTWWqrjq4ysjThoxDoWmsxK1mdoTJr5pXj5jX0Er3hDdrNfvZ0Ax00sDURQePb']!;

  // ✅ Initialize Firebase properly using FlutterFire config
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Start the app with Riverpod
  runApp(const ProviderScope(child: LocalSkillShareApp()));
}
