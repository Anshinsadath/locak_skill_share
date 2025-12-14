// lib/core/services/profile_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/user_profile.dart';

class ProfileService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // GET USER PROFILE (stream)
  Stream<UserProfile?> getUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.data()!);
    });
  }

  // UPDATE / CREATE PROFILE
  Future<void> updateProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(
          profile.toMap(),
          SetOptions(merge: true),
        );
  }

  // UPLOAD PROFILE IMAGE (returns download URL)
  Future<String> uploadProfileImage(String uid, File image) async {
    final ref = _storage.ref().child("profile_images/$uid.jpg");
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
