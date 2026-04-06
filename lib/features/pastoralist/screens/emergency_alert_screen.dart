import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../data/models/emergency_alert.dart';
import '../../../data/repositories/emergency_alert_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _messageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final alert = EmergencyAlert(
        id: '',
        pastoralistId: user.uid,
        message: _messageController.text.trim(),
        location: _locationController.text.trim(),
        status: 'open',
        createdAt: DateTime.now(),
      );

      await EmergencyAlertRepository().createAlert(alert);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emergency alert sent.')),
        );
        _formKey.currentState!.reset();
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to send alert.';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Alert')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _messageController,
                      label: 'What happened?',
                      validator: (value) =>
                          Validators.requiredText(value, 'Message'),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _locationController,
                      label: 'Location',
                      validator: (value) =>
                          Validators.requiredText(value, 'Location'),
                    ),
                  ],
                ),
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
                label: _isLoading ? 'Sending...' : 'Send Alert',
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
