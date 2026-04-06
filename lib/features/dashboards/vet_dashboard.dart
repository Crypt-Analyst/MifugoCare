import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../vet/screens/vet_emergency_alerts_screen.dart';
import '../vet/screens/vet_health_record_screen.dart';
import '../vet/screens/vet_requests_screen.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActionCard(
            title: 'Appointments',
            subtitle: 'Accept or decline requests',
            icon: Icons.event_note,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VetRequestsScreen()),
              );
            },
          ),
          _ActionCard(
            title: 'Emergency Alerts',
            subtitle: 'Respond to urgent requests',
            icon: Icons.sos,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VetEmergencyAlertsScreen(),
                ),
              );
            },
          ),
          _ActionCard(
            title: 'Health Records',
            subtitle: 'Update treatments & vaccinations',
            icon: Icons.health_and_safety,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VetHealthRecordScreen(),
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
