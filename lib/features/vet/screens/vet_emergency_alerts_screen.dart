import 'package:flutter/material.dart';

import '../../../data/models/emergency_alert.dart';
import '../../../data/repositories/emergency_alert_repository.dart';

class VetEmergencyAlertsScreen extends StatelessWidget {
  const VetEmergencyAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Alerts')),
      body: StreamBuilder<List<EmergencyAlert>>(
        stream: EmergencyAlertRepository().streamOpenAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data ?? [];
          if (alerts.isEmpty) {
            return const Center(child: Text('No open alerts.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Card(
                child: ListTile(
                  title: Text(alert.message),
                  subtitle: Text('Location: ${alert.location}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      EmergencyAlertRepository().updateStatus(
                        alertId: alert.id,
                        status: value,
                      );
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'in_progress',
                        child: Text('Mark In Progress'),
                      ),
                      PopupMenuItem(
                        value: 'resolved',
                        child: Text('Mark Resolved'),
                      ),
                    ],
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
