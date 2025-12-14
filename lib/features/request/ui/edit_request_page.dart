import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/help_request.dart';
import '../../../core/services/request_service.dart';

class EditRequestPage extends ConsumerStatefulWidget {
  final HelpRequest request;

  const EditRequestPage({super.key, required this.request});

  @override
  ConsumerState<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends ConsumerState<EditRequestPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.request.title;
    descController.text = widget.request.description;
    priceController.text = widget.request.price.toString();
  }

  Future<void> saveChanges() async {
    setState(() => loading = true);

    final service = ref.read(requestServiceProvider);

    final updated = widget.request.copyWith(
      title: titleController.text.trim(),
      description: descController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? widget.request.price,
    );

    await service.updateRequest(updated.id, updated.toMap());

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Request")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price (BHD)"),
            ),
            const SizedBox(height: 25),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveChanges,
                    child: const Text("Save Changes"),
                  )
          ],
        ),
      ),
    );
  }
}
