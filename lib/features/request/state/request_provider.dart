import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/request_service.dart';
import '../../../models/help_request.dart';

final requestServiceProvider = Provider((ref) => RequestService());

final requestListProvider = StreamProvider<List<HelpRequest>>((ref) {
  return ref.read(requestServiceProvider).getRequests();
});
