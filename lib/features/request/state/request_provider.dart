import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/help_request.dart';
import 'package:local_skill_share/core/services/request_service.dart';


// --- STREAM ALL REQUESTS ---
final requestListProvider =
    StreamProvider.autoDispose<List<HelpRequest>>((ref) {
  final service = ref.watch(requestServiceProvider);

  return service.getAllRequests();
});
