import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/accepted_requests_provider.dart';
import '../../../models/help_request.dart';
import '../../../core/widgets/gradient_app_bar.dart';

class AcceptedRequestsPage extends ConsumerWidget {
  const AcceptedRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptedAsync = ref.watch(acceptedRequestsProvider);

    return Scaffold(
      appBar: const GradientAppBar(title: "Accepted Requests"),

      body: acceptedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text("No accepted requests yet."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (_, i) {
              final r = requests[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(r.title),
                  subtitle: Text("Status: ${r.status}"),
                  trailing: const Icon(Icons.arrow_forward),
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
