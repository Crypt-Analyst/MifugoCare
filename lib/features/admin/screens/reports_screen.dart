import 'package:flutter/material.dart';

import '../../../data/models/report.dart';
import '../../../data/repositories/report_repository.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: StreamBuilder<List<Report>>(
        stream: ReportRepository().streamOpenReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return const Center(child: Text('No open reports.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                child: ListTile(
                  title: Text('${report.targetType} ${report.targetId}'),
                  subtitle: Text(report.reason),
                  trailing: TextButton(
                    onPressed: () => ReportRepository().updateStatus(
                      reportId: report.id,
                      status: 'resolved',
                    ),
                    child: const Text('Resolve'),
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
