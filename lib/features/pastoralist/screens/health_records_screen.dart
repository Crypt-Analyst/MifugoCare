import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/health_record.dart';
import '../../../data/repositories/health_record_repository.dart';

class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: StreamBuilder<List<HealthRecord>>(
        stream: HealthRecordRepository().streamForPastoralist(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(child: Text('No health records yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                child: ListTile(
                  title: Text(record.summary),
                  subtitle: Text(record.treatment),
                  trailing: Text(
                    record.createdAt.toLocal().toString().split(' ')[0],
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
