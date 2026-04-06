import 'package:flutter/material.dart';

import '../../../data/models/livestock.dart';
import '../../../data/repositories/livestock_repository.dart';

class ListingModerationScreen extends StatelessWidget {
  const ListingModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Moderation')),
      body: StreamBuilder<List<Livestock>>(
        stream: LivestockRepository().streamAllListings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final listings = snapshot.data ?? [];
          if (listings.isEmpty) {
            return const Center(child: Text('No listings found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: listings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = listings[index];
              final isActive = item.status == 'active';
              return Card(
                child: ListTile(
                  title: Text('${item.name} (${item.type})'),
                  subtitle: Text('${item.location} · ${item.healthStatus}'),
                  trailing: TextButton(
                    onPressed: () => LivestockRepository().updateStatus(
                      livestockId: item.id,
                      status: isActive ? 'suspended' : 'active',
                    ),
                    child: Text(isActive ? 'Suspend' : 'Activate'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
