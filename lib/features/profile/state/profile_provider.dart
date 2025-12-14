import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/profile_service.dart';
import '../../auth/state/user_provider.dart';
import '../../../models/user_profile.dart';


// PROVIDER FOR PROFILE SERVICE
final profileServiceProvider = Provider((ref) => ProfileService());

// STREAM USER PROFILE
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final firebaseUser = ref.watch(firebaseUserProvider).value;
  if (firebaseUser == null) return const Stream.empty();

  final service = ref.watch(profileServiceProvider);
  return service.getUserProfile(firebaseUser.uid);
});
