import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../shared/widgets/dashboard_action_card.dart';
import '../../shared/widgets/dashboard_header.dart';
import '../vet/screens/vet_emergency_alerts_screen.dart';
import '../vet/screens/vet_health_record_screen.dart';
import '../vet/screens/vet_requests_screen.dart';

class VetDashboard extends StatelessWidget {
  const VetDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet Center'),
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
            title: 'On-call services',
            subtitle: 'Respond to requests and update records',
            icon: Icons.local_hospital,
          ),
          const SizedBox(height: 20),
          DashboardActionCard(
            title: 'Appointments',
            subtitle: 'Accept or decline requests',
            icon: Icons.event_note,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VetRequestsScreen()),
              );
            },
          ),
          DashboardActionCard(
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
          DashboardActionCard(
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
