import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/state/user_provider.dart';
import '../state/profile_provider.dart';
import '../../../models/user_profile.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final nameController = TextEditingController();
  File? selectedImage;
  bool loading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> saveProfile() async {
    final user = ref.read(firebaseUserProvider).value;
    if (user == null) return;

    setState(() => loading = true);

    final service = ref.read(profileServiceProvider);

    String? imageUrl;

    if (selectedImage != null) {
      try {
        imageUrl = await service.uploadProfileImage(user.uid, selectedImage!);
      } catch (e) {
        debugPrint("Upload failed: $e");
      }
    }

    final updated = UserProfile(
      uid: user.uid,
      email: user.email ?? "",
      name: nameController.text.trim(),
      photoUrl: imageUrl ?? "",
    );

    await service.updateProfile(updated);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (profile) {
          if (profile != null && nameController.text.isEmpty) {
            nameController.text = profile.name;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : (profile?.photoUrl != null &&
                                profile!.photoUrl!.isNotEmpty)
                            ? NetworkImage(profile.photoUrl!)
                            : null,
                    child: selectedImage == null &&
                            (profile?.photoUrl == null ||
                                profile!.photoUrl!.isEmpty)
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: saveProfile,
                        child: const Text("Save"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
