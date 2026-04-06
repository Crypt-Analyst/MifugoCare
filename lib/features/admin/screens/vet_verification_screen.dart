import 'package:flutter/material.dart';

import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_repository.dart';

class VetVerificationScreen extends StatelessWidget {
  const VetVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vet Verification')),
      body: StreamBuilder<List<UserProfile>>(
        stream: UserRepository().streamVets(isVerified: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final vets = snapshot.data ?? [];
          if (vets.isEmpty) {
            return const Center(child: Text('No pending vets.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final vet = vets[index];
              return Card(
                child: ListTile(
                  title: Text(vet.displayName),
                  subtitle: Text(vet.email),
                  trailing: ElevatedButton(
                    onPressed: () => UserRepository().updateVerification(
                      uid: vet.uid,
                      isVerified: true,
                    ),
                    child: const Text('Approve'),
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
