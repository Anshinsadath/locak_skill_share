import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/help_request.dart';
import '../state/user_requests_provider.dart';
import '../../../core/services/request_service.dart';

class MyRequestsPage extends ConsumerWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(userRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Requests")),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text("No requests yet."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (_, i) {
              HelpRequest r = requests[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(r.title),
                  subtitle: Text("Status: ${r.status}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          context.push('/edit-request', extra: r);
                        },
                      ),
                      // Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Delete Request"),
                              content: const Text("Are you sure you want to delete this request?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete")),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref.read(requestServiceProvider).deleteRequest(r.id);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push('/request-details', extra: r);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
