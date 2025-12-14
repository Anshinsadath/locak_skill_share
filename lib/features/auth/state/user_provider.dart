import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/app_user.dart';

/// This provider listens to Firebase Auth changes (user login/logout)
final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// This provider loads the AppUser profile from Firestore
final appUserProvider = FutureProvider<AppUser?>((ref) async {
  final firebaseUser = ref.watch(firebaseUserProvider).value;

  if (firebaseUser == null) return null;

  final snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseUser.uid)
      .get();

  if (!snapshot.exists) return null;

  return AppUser.fromMap(snapshot.data()!);
});
