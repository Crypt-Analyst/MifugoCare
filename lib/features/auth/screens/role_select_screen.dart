import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../shared/widgets/app_button.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key, required this.user});

  final User user;

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  UserRole _role = UserRole.pastoralist;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _saveRole() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profile = UserProfile(
        uid: widget.user.uid,
        email: widget.user.email ?? '',
        displayName: widget.user.displayName ?? 'New user',
        role: _role,
        isVerified: _role == UserRole.vet ? false : true,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await UserRepository().createProfile(profile);
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to save role.';
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
      appBar: AppBar(title: const Text('Select Role')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Choose your role to complete setup.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<UserRole>(
                value: _role,
                items: const [
                  DropdownMenuItem(
                    value: UserRole.pastoralist,
                    child: Text('Pastoralist'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.vet,
                    child: Text('Veterinary Officer'),
                  ),
                  DropdownMenuItem(
                    value: UserRole.buyer,
                    child: Text('Buyer'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _role = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              AppButton(
                label: _isLoading ? 'Saving...' : 'Continue',
                onPressed: _isLoading ? null : _saveRole,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
