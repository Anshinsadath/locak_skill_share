import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/help_request.dart';
import '../../auth/state/user_provider.dart';

final acceptedRequestsProvider = StreamProvider<List<HelpRequest>>((ref) {
  final user = ref.watch(firebaseUserProvider).value;

  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection("requests")
      .where("acceptedBy", isEqualTo: user.uid)
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => HelpRequest.fromMap(d.data(), d.id))
          .toList());
});
