import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/vet_request.dart';
import '../../../data/repositories/vet_request_repository.dart';

class VetRequestsScreen extends StatelessWidget {
  const VetRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login required.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vet Requests')),
      body: StreamBuilder<List<VetRequest>>(
        stream: VetRequestRepository().streamForVet(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data ?? [];
          if (requests.isEmpty) {
            return const Center(child: Text('No requests yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                child: ListTile(
                  title: Text('Request from ${request.pastoralistId}'),
                  subtitle: Text(
                    '${request.notes} \n${request.preferredDate.toLocal().toString().split(' ')[0]}',
                  ),
                  isThreeLine: true,
                  trailing: _StatusChip(status: request.status),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _VetRequestActions(userId: user.uid),
    );
  }
}

class _VetRequestActions extends StatefulWidget {
  const _VetRequestActions({required this.userId});

  final String userId;

  @override
  State<_VetRequestActions> createState() => _VetRequestActionsState();
}

class _VetRequestActionsState extends State<_VetRequestActions> {
  String? _selectedRequestId;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _updateStatus(String status) async {
    if (_selectedRequestId == null) {
      setState(() {
        _errorMessage = 'Select a request first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await VetRequestRepository().updateStatus(
        requestId: _selectedRequestId!,
        status: status,
      );
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to update status.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<VetRequest>>(
      stream: VetRequestRepository().streamForVet(widget.userId),
      builder: (context, snapshot) {
        final requests = snapshot.data ?? [];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedRequestId,
                items: requests
                    .map(
                      (request) => DropdownMenuItem(
                        value: request.id,
                        child: Text(
                          '${request.pastoralistId} (${request.status})',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRequestId = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select request to update',
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _updateStatus('accepted'),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => _updateStatus('declined'),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'accepted' => Colors.green,
      'declined' => Colors.red,
      _ => Colors.orange,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color),
      ),
    );
  }
}
