import 'package:flutter/material.dart';

import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_repository.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: StreamBuilder<List<UserProfile>>(
        stream: UserRepository().streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  title: Text(user.displayName),
                  subtitle: Text('${user.email} · ${user.role.name}'),
                  trailing: Switch(
                    value: user.isActive,
                    onChanged: (value) => UserRepository().updateActive(
                      uid: user.uid,
                      isActive: value,
                    ),
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
