import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

class AccountDisabledScreen extends StatelessWidget {
  const AccountDisabledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Disabled')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your account has been disabled.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text('Contact support or the admin for help.'),
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
