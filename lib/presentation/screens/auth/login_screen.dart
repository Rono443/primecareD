import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
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
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Brand Logo/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
              ),
              const SizedBox(height: 8),
              const Text(
                'Let\'s get your clothes cleaned and fresh.',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              
              // Input Fields
              const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'name@example.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Role Selector for Login
              Row(
                children: [
                  const Text('Login as:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 12),
                  _buildRoleTag('Customer', true),
                  _buildRoleTag('Rider', false),
                  _buildRoleTag('Staff', false),
                ],
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shadowColor: AppColors.secondary.withOpacity(0.4),
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New here?", style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('Create Account', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Quick Login (Demo)',
                  style: TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              _buildDemoLogins(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTag(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDemoLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDemoChip('Admin', () {
          _emailController.text = 'admin@pc.com';
          _passwordController.text = 'password123';
        }),
        _buildDemoChip('Staff', () {
          _emailController.text = 'staff@pc.com';
          _passwordController.text = 'password123';
        }),
        _buildDemoChip('Rider', () {
          _emailController.text = 'rider@pc.com';
          _passwordController.text = 'password123';
        }),
      ],
    );
  }

  Widget _buildDemoChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      backgroundColor: AppColors.background,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
