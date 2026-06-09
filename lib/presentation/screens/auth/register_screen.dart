import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  UserRole _selectedRole = UserRole.customer;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        _selectedRole,
      );
      if (mounted) {
        final user = ref.read(authProvider);
        if (user != null) {
          _redirectUser(user.role);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _redirectUser(UserRole role) {
    switch (role) {
      case UserRole.superAdmin: context.go('/admin-dashboard'); break;
      case UserRole.laundryStaff: context.go('/staff-home'); break;
      case UserRole.deliveryRider: context.go('/rider-home'); break;
      default: context.go('/customer-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                ),
                const Text(
                  'Join PrimeCare Laundry today.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) => v!.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Register As', prefixIcon: Icon(Icons.badge_outlined)),
                  items: [
                    DropdownMenuItem(value: UserRole.customer, child: Text('Customer')),
                    DropdownMenuItem(value: UserRole.deliveryRider, child: Text('Delivery Rider')),
                    DropdownMenuItem(value: UserRole.laundryStaff, child: Text('Laundry Staff')),
                  ],
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('REGISTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
