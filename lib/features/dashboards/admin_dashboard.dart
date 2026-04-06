import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../admin/screens/listing_moderation_screen.dart';
import '../admin/screens/reports_screen.dart';
import '../admin/screens/user_management_screen.dart';
import '../admin/screens/vet_verification_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthRepository().signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActionCard(
            title: 'Vet Verification',
            subtitle: 'Approve veterinary officers',
            icon: Icons.verified_user,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VetVerificationScreen(),
                ),
              );
            },
          ),
          _ActionCard(
            title: 'User Management',
            subtitle: 'Activate or deactivate users',
            icon: Icons.manage_accounts,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UserManagementScreen(),
                ),
              );
            },
          ),
          _ActionCard(
            title: 'Listing Moderation',
            subtitle: 'Suspend or approve listings',
            icon: Icons.inventory_2,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ListingModerationScreen(),
                ),
              );
            },
          ),
          _ActionCard(
            title: 'Reports',
            subtitle: 'Review misuse reports',
            icon: Icons.report_problem,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReportsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
