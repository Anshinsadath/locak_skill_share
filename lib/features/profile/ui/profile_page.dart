import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/state/user_provider.dart';
import '../state/profile_provider.dart';
import 'edit_profile_page.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/gradient_app_bar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final firebaseUser = ref.watch(firebaseUserProvider).value;

    return profileAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
      data: (profile) {
        return Scaffold(
          appBar: GradientAppBar(
  title: "Profile",
  actions: [
    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EditProfilePage(),
          ),
        );
      },
    ),
  ],
),


          

          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: (profile?.photoUrl != null &&
                          profile!.photoUrl!.isNotEmpty)
                      ? NetworkImage(profile.photoUrl!)
                      : null,
                  child: (profile?.photoUrl == null ||
                          profile!.photoUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 20),
                Text("Name: ${profile?.name ?? 'No name'}",
                    style: const TextStyle(fontSize: 18)),
                Text("Email: ${firebaseUser?.email ?? ''}",
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService().logout();
                    if (context.mounted) context.go('/login');
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
