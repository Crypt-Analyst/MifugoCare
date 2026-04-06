import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/livestock.dart';
import '../../../data/repositories/livestock_repository.dart';
import '../../../data/repositories/saved_listing_repository.dart';
import 'buyer_message_screen.dart';

class BuyerListingsScreen extends StatefulWidget {
  const BuyerListingsScreen({super.key});

  @override
  State<BuyerListingsScreen> createState() => _BuyerListingsScreenState();
}

class _BuyerListingsScreenState extends State<BuyerListingsScreen> {
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _healthController = TextEditingController();

  @override
  void dispose() {
    _typeController.dispose();
    _locationController.dispose();
    _healthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Livestock')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: 'Type (e.g., Cattle)',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _healthController,
                  decoration: const InputDecoration(labelText: 'Health status'),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Livestock>>(
              stream: LivestockRepository().streamListings(
                type: _typeController.text.trim(),
                location: _locationController.text.trim(),
                healthStatus: _healthController.text.trim(),
              ),
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
                    return Card(
                      child: ListTile(
                        title: Text('${item.name} (${item.type})'),
                        subtitle: Text('${item.location} · ${item.healthStatus}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.bookmark_border),
                              onPressed: () async {
                                final user =
                                    FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  return;
                                }
                                final repository = SavedListingRepository();
                                final existing = await repository.findSaved(
                                  buyerId: user.uid,
                                  livestockId: item.id,
                                );
                                if (existing != null) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Already saved.'),
                                      ),
                                    );
                                  }
                                  return;
                                }
                                await repository.saveListing(
                                  buyerId: user.uid,
                                  livestockId: item.id,
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Listing saved.'),
                                    ),
                                  );
                                }
                              },
                            ),
                            const Icon(Icons.message_outlined),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BuyerMessageScreen(livestock: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
