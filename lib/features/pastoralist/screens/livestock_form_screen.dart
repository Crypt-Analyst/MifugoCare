import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../data/models/livestock.dart';
import '../../../data/repositories/livestock_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class LivestockFormScreen extends StatefulWidget {
  const LivestockFormScreen({super.key});

  @override
  State<LivestockFormScreen> createState() => _LivestockFormScreenState();
}

class _LivestockFormScreenState extends State<LivestockFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _healthController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _healthController.dispose();
    _priceController.dispose();
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
      final age = int.parse(_ageController.text.trim());
      final price = _priceController.text.trim().isEmpty
          ? null
          : double.tryParse(_priceController.text.trim());

      final livestock = Livestock(
        id: '',
        ownerId: user.uid,
        name: _nameController.text.trim(),
        type: _typeController.text.trim(),
        breed: _breedController.text.trim(),
        ageMonths: age,
        location: _locationController.text.trim(),
        healthStatus: _healthController.text.trim(),
        price: price,
        createdAt: DateTime.now(),
      );

      await LivestockRepository().addLivestock(livestock);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to save livestock.';
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
      appBar: AppBar(title: const Text('Add Livestock')),
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
                        controller: _nameController,
                        label: 'Name',
                        validator: (value) =>
                            Validators.requiredText(value, 'Name'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _typeController,
                        label: 'Type (Cattle, Goat)',
                        validator: (value) =>
                            Validators.requiredText(value, 'Type'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _breedController,
                        label: 'Breed',
                        validator: (value) =>
                            Validators.requiredText(value, 'Breed'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _ageController,
                        label: 'Age (months)',
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            Validators.requiredText(value, 'Age'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _locationController,
                        label: 'Location',
                        validator: (value) =>
                            Validators.requiredText(value, 'Location'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _healthController,
                        label: 'Health status',
                        validator: (value) =>
                            Validators.requiredText(value, 'Health status'),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _priceController,
                        label: 'Price (optional)',
                        keyboardType: TextInputType.number,
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
                  label: _isLoading ? 'Saving...' : 'Save Livestock',
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
