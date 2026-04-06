import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/livestock.dart';
import '../../../data/models/saved_listing.dart';
import '../../../data/repositories/livestock_repository.dart';
import '../../../data/repositories/saved_listing_repository.dart';
import 'buyer_message_screen.dart';

class BuyerSavedListingsScreen extends StatelessWidget {
  const BuyerSavedListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Listings')),
      body: StreamBuilder<List<SavedListing>>(
        stream: SavedListingRepository().streamForBuyer(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final saved = snapshot.data ?? [];
          if (saved.isEmpty) {
            return const Center(child: Text('No saved listings yet.'));
          }

          final ids = saved.map((item) => item.livestockId).toList();
          return FutureBuilder<List<Livestock>>(
            future: LivestockRepository().fetchByIds(ids),
            builder: (context, livestockSnapshot) {
              if (livestockSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final listings = livestockSnapshot.data ?? [];
              if (listings.isEmpty) {
                return const Center(child: Text('Listings not found.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: listings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = listings[index];
                  return Card(
                    child: ListTile(
                      title: Text('${item.name} (${item.type})'),
                      subtitle: Text('${item.location} · ${item.healthStatus}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.message_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BuyerMessageScreen(livestock: item),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
