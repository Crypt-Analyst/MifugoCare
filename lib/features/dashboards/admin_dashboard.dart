import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/dashboard_action_card.dart';
import '../../shared/widgets/dashboard_header.dart';
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
        title: const Text('Admin Control'),
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
          const DashboardHeader(
            title: 'System oversight',
            subtitle: 'Verify vets and protect market integrity',
            icon: Icons.shield,
          ),
          const SizedBox(height: 20),
          DashboardActionCard(
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
          DashboardActionCard(
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
          DashboardActionCard(
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
          DashboardActionCard(
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
