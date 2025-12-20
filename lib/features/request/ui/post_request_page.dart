import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/request_service.dart';
import '../../../models/help_request.dart';
import '../../auth/state/user_provider.dart';

class PostRequestPage extends ConsumerStatefulWidget {
  const PostRequestPage({super.key});

  @override
  ConsumerState<PostRequestPage> createState() => _PostRequestPageState();
}

class _PostRequestPageState extends ConsumerState<PostRequestPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController(); // ✅ SINGLE description controller
  final priceController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> submitRequest() async {
    final user = ref.read(firebaseUserProvider).value;
    if (user == null) return;

    setState(() => loading = true);

    final service = ref.read(requestServiceProvider);

    final request = HelpRequest(
      id: '',
      title: titleController.text.trim(),
      description: descController.text.trim(),
      price: double.parse(priceController.text),
      userId: user.uid,
      createdAt: Timestamp.now(),
      status: 'pending',
      acceptedBy: null,

      // 💳 PAYMENT FIELDS
      paymentStatus: 'unpaid',
      paymentExpiryAt: null, // not accepted yet
      paidAt: null,
      paymentIntentId: null,
    );

    await service.createRequest(request);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: const Text("Post Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price (BHD)"),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: submitRequest,
                    child: const Text("Submit Request"),
                  ),
          ],
        ),
      ),
    );
  }
}
