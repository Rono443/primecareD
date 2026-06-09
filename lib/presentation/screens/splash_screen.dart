import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/user_model.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      final user = ref.read(authProvider);
      if (user != null) {
        _redirectBasedOnRole(user.role);
      } else {
        context.go('/login');
      }
    } catch (e) {
      debugPrint('Auth check failed: $e');
      // If auth fails (e.g. Firebase not configured), go to login anyway
      if (mounted) {
        context.go('/login');
      }
    }
  }

  void _redirectBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        context.go('/admin-dashboard');
        break;
      case UserRole.laundryStaff:
        context.go('/staff-home');
        break;
      case UserRole.deliveryRider:
        context.go('/rider-home');
        break;
      default:
        context.go('/customer-home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to redirect if it happens after delay
    ref.listen(authProvider, (previous, next) {
      if (next != null) {
        _redirectBasedOnRole(next.role);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 180, height: 180),
            const SizedBox(height: 24),
            const Text(
              'PRIMECARE LAUNDRY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const SpinKitWave(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
