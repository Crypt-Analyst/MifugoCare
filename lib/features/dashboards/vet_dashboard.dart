import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';

class VetDashboard extends StatelessWidget {
  const VetDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthRepository().signOut(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Vet requests and appointments go here.'),
      ),
    );
  }
}
