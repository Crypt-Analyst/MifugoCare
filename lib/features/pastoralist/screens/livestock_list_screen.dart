import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/livestock.dart';
import '../../../data/repositories/livestock_repository.dart';
import 'livestock_form_screen.dart';

class LivestockListScreen extends StatelessWidget {
  const LivestockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Livestock')),
      body: StreamBuilder<List<Livestock>>(
        stream: LivestockRepository().streamByOwner(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final livestock = snapshot.data ?? [];
          if (livestock.isEmpty) {
            return const Center(child: Text('No livestock listed yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: livestock.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = livestock[index];
              return Card(
                child: ListTile(
                  title: Text('${item.name} (${item.type})'),
                  subtitle: Text('${item.location} · ${item.healthStatus}'),
                  trailing: Text(item.price == null
                      ? 'N/A'
                      : 'KES ${item.price!.toStringAsFixed(0)}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LivestockFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
