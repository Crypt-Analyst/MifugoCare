import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../pastoralist/screens/emergency_alert_screen.dart';
import '../pastoralist/screens/health_records_screen.dart';
import '../pastoralist/screens/livestock_list_screen.dart';
import '../pastoralist/screens/vet_request_screen.dart';

class PastoralistDashboard extends StatelessWidget {
  const PastoralistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastoralist Dashboard'),
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
          Text(
            'Welcome ${user?.email ?? ''}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'Request Vet',
            subtitle: 'Book a vet appointment',
            icon: Icons.medical_services_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VetRequestScreen()),
              );
            },
          ),
          _ActionCard(
            title: 'Emergency Alert',
            subtitle: 'Send an urgent request',
            icon: Icons.warning_amber_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EmergencyAlertScreen()),
              );
            },
          ),
          _ActionCard(
            title: 'My Livestock',
            subtitle: 'Manage your listings',
            icon: Icons.pets_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LivestockListScreen()),
              );
            },
          ),
          _ActionCard(
            title: 'Health Records',
            subtitle: 'View treatments and vaccinations',
            icon: Icons.health_and_safety_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HealthRecordsScreen()),
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
