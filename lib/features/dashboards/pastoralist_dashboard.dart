import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/dashboard_action_card.dart';
import '../../shared/widgets/dashboard_header.dart';
import '../pastoralist/screens/emergency_alert_screen.dart';
import '../pastoralist/screens/health_records_screen.dart';
import '../pastoralist/screens/livestock_list_screen.dart';
import '../pastoralist/screens/pastoralist_messages_screen.dart';
import '../pastoralist/screens/vet_request_screen.dart';

class PastoralistDashboard extends StatelessWidget {
  const PastoralistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastoralist Hub'),
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
          DashboardHeader(
            title: 'Care for your herd',
            subtitle: 'Manage health, sales, and vet services',
            caption: user?.email ?? 'Stay connected to your vet network',
            icon: Icons.agriculture,
          ),
          const SizedBox(height: 20),
          DashboardActionCard(
            title: 'Request Vet',
            subtitle: 'Book a vet appointment',
            icon: Icons.medical_services_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VetRequestScreen()),
              );
            },
          ),
          DashboardActionCard(
            title: 'Emergency Alert',
            subtitle: 'Send an urgent request',
            icon: Icons.warning_amber_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EmergencyAlertScreen()),
              );
            },
          ),
          DashboardActionCard(
            title: 'My Livestock',
            subtitle: 'Manage your listings',
            icon: Icons.pets_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LivestockListScreen()),
              );
            },
          ),
          DashboardActionCard(
            title: 'Health Records',
            subtitle: 'View treatments and vaccinations',
            icon: Icons.health_and_safety_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HealthRecordsScreen()),
              );
            },
          ),
          DashboardActionCard(
            title: 'Buyer Messages',
            subtitle: 'Reply to buyer inquiries',
            icon: Icons.chat_bubble_outline,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PastoralistMessagesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
