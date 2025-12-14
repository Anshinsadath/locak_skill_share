import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/help_request.dart';
import '../../auth/state/user_provider.dart';
import 'package:local_skill_share/core/services/request_service.dart';


// STREAM ONLY CURRENT USER'S REQUESTS
final userRequestsProvider =
    StreamProvider.autoDispose<List<HelpRequest>>((ref) {
  final user = ref.watch(firebaseUserProvider).value;
  if (user == null) return const Stream.empty();

  final service = ref.watch(requestServiceProvider);
  return service.getUserRequests(user.uid);
});
