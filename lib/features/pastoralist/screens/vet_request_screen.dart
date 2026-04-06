import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/vet_request.dart';
import '../../../data/repositories/vet_request_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class VetRequestScreen extends StatefulWidget {
  const VetRequestScreen({super.key});

  @override
  State<VetRequestScreen> createState() => _VetRequestScreenState();
}

class _VetRequestScreenState extends State<VetRequestScreen> {
  final _notesController = TextEditingController();
  DateTime _preferredDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedVetId;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _selectedVetId == null) {
      setState(() {
        _errorMessage = 'Select a vet and try again.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = VetRequest(
        id: '',
        pastoralistId: user.uid,
        vetId: _selectedVetId!,
        notes: _notesController.text.trim(),
        preferredDate: _preferredDate,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await VetRequestRepository().createRequest(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent.')),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to send request.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _preferredDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _preferredDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Vet')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select a veterinary officer'),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'vet')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final vets = snapshot.data?.docs ?? [];
                  if (vets.isEmpty) {
                    return const Text('No vets available yet.');
                  }

                  return DropdownButtonFormField<String>(
                    value: _selectedVetId,
                    items: vets
                        .map(
                          (doc) => DropdownMenuItem(
                            value: doc.id,
                            child: Text(doc['displayName'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVetId = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Vet'),
                  );
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _notesController,
                label: 'Notes (optional)',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Preferred date: ${_preferredDate.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pick date'),
                  ),
                ],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              AppButton(
                label: _isLoading ? 'Sending...' : 'Send Request',
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
