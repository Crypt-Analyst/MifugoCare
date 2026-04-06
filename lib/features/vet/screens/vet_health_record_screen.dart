import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../data/models/health_record.dart';
import '../../../data/repositories/health_record_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class VetHealthRecordScreen extends StatefulWidget {
  const VetHealthRecordScreen({super.key});

  @override
  State<VetHealthRecordScreen> createState() => _VetHealthRecordScreenState();
}

class _VetHealthRecordScreenState extends State<VetHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _livestockIdController = TextEditingController();
  final _pastoralistIdController = TextEditingController();
  final _summaryController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _vaccinationController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _livestockIdController.dispose();
    _pastoralistIdController.dispose();
    _summaryController.dispose();
    _treatmentController.dispose();
    _vaccinationController.dispose();
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
      final record = HealthRecord(
        id: '',
        livestockId: _livestockIdController.text.trim(),
        pastoralistId: _pastoralistIdController.text.trim(),
        vetId: user.uid,
        summary: _summaryController.text.trim(),
        treatment: _treatmentController.text.trim(),
        vaccination: _vaccinationController.text.trim(),
        createdAt: DateTime.now(),
      );

      await HealthRecordRepository().createRecord(record);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Health record saved.')),
        );
        _formKey.currentState!.reset();
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to save record.';
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
      appBar: AppBar(title: const Text('Update Health Record')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _livestockIdController,
                        label: 'Livestock ID',
                        validator: (value) =>
                            Validators.requiredText(value, 'Livestock ID'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _pastoralistIdController,
                        label: 'Pastoralist ID',
                        validator: (value) =>
                            Validators.requiredText(value, 'Pastoralist ID'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _summaryController,
                        label: 'Summary',
                        validator: (value) =>
                            Validators.requiredText(value, 'Summary'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _treatmentController,
                        label: 'Treatment',
                        validator: (value) =>
                            Validators.requiredText(value, 'Treatment'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _vaccinationController,
                        label: 'Vaccination',
                        validator: (value) =>
                            Validators.requiredText(value, 'Vaccination'),
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
                  label: _isLoading ? 'Saving...' : 'Save Record',
                  onPressed: _isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
