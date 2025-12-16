import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:local_skill_share/features/request/state/request_provider.dart';
import '../../request/ui/request_details_page.dart';
import '../../../core/widgets/gradient_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestStream = ref.watch(requestListProvider);

    return Scaffold(
      appBar: const GradientAppBar(title: "Local Skill Share"),
      body: requestStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text("No help requests yet"));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (_, i) {
              final r = requests[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(r.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text("${r.price} BHD", style: const TextStyle(fontWeight: FontWeight.w600)),
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
