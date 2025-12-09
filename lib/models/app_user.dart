// lib/models/app_user.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final Timestamp createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'createdAt': createdAt,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      phone: map['phone'] as String?,
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }
}
