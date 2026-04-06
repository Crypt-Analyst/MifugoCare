import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

class VetPendingScreen extends StatelessWidget {
  const VetPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification Pending')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your vet account is awaiting approval.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text('Please wait for admin verification.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => AuthRepository().signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
