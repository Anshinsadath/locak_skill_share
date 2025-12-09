// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  // Register and also create Firestore profile
  Future<User?> register(String email, String password, {String? name, String? phone}) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      final profile = AppUser(
        uid: user.uid,
        email: user.email ?? email,
        name: name,
        phone: phone,
        createdAt: Timestamp.now(),
      );
      await _firestore.createUserProfile(profile);
    }

    return user;
  }

  // Login
  Future<User?> login(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Auth state
  Stream<User?> get authState => _auth.authStateChanges();
}
