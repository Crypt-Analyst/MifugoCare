import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/validators.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _role = UserRole.pastoralist;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await AuthRepository().registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;
      if (user == null) {
        throw StateError('Registration failed.');
      }

      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? _emailController.text.trim(),
        displayName: _nameController.text.trim(),
        role: _role,
        isVerified: _role == UserRole.vet ? false : true,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await UserRepository().createProfile(profile);
    } on FirebaseAuthException catch (error) {
      setState(() {
        _errorMessage = error.message ?? 'Registration failed.';
      });
    } on StateError catch (error) {
      setState(() {
        _errorMessage = error.message;
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
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _nameController,
                        label: 'Full name',
                        validator: (value) =>
                            Validators.requiredText(value, 'Full name'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        isPassword: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 16),
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
                        decoration: const InputDecoration(
                          labelText: 'Role',
                        ),
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
                const SizedBox(height: 24),
                AppButton(
                  label: _isLoading ? 'Creating...' : 'Create Account',
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
