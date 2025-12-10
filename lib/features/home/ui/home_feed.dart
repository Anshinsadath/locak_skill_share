import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../request/state/request_provider.dart';
import '../../../models/help_request.dart';

class HomeFeed extends ConsumerWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestList = ref.watch(requestListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Requests")),
      body: requestList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text("No requests yet."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final HelpRequest r = requests[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(r.title),
                  subtitle: Text(r.description),
                  trailing: Text("\$${r.price.toString()}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
