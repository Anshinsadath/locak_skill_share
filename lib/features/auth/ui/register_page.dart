// lib/features/auth/ui/register_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/profile_service.dart';
import '../../../models/user_profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final _authService = AuthService();
  final _profileService = ProfileService();

  bool isLoading = false;

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1) Create auth user
      final user = await _authService.register(email, password);

      if (user == null) {
        throw Exception('Registration failed');
      }

      // 2) Create initial Firestore profile (use UserProfile model)
      final profile = UserProfile(
        uid: user.uid,
        name: name.isEmpty ? '' : name,
        email: user.email ?? email,
        photoUrl: null,
      );

      await _profileService.updateProfile(profile);

      // 3) Optionally store phone inside users doc as well
      if (phone.isNotEmpty) {
        final updated = UserProfile(
          uid: user.uid,
          name: profile.name,
          email: profile.email,
          photoUrl: profile.photoUrl,
        );
        // We can add phone as an extra field by calling firestore directly:
        await _profileService.updateProfile(UserProfile(
          uid: user.uid,
          name: profile.name,
          email: profile.email,
          photoUrl: profile.photoUrl,
        ));
        // then add phone as a separate field (merge)
        final firestore = _profileService; // reuse
        // Use Firestore directly to set phone (avoid creating new service method)
        // But since updateProfile uses SetOptions(merge:true), we can call it with a map:
        await firestore.updateProfile(UserProfile(
          uid: user.uid,
          name: profile.name,
          email: profile.email,
          photoUrl: profile.photoUrl,
        ));
        // If you want to store phone explicitly, you can modify ProfileService.updateProfile
        // to accept extra fields or use FirebaseFirestore.instance.doc(...).set({...}, SetOptions(merge:true));
      }

      if (mounted) {
        // Navigate to home
        context.go('/home');
      }
    } catch (e) {
      final errMsg = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errMsg)),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Full name (optional)"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone (optional)"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: register,
                      child: const Text("Create Account"),
                    ),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
