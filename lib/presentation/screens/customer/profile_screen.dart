import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../legal_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: user?.profilePicture != null 
                ? ClipOval(child: Image.network(user!.profilePicture!, width: 100, height: 100, fit: BoxFit.cover))
                : Text(user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Guest User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildProfileTile(Icons.person_outline, 'Edit Profile', () {}),
            _buildProfileTile(Icons.location_on_outlined, 'Manage Addresses', () {}),
            _buildProfileTile(Icons.payment_outlined, 'Payment Methods', () {}),
            _buildProfileTile(Icons.notifications_outlined, 'Notification Preferences', () {}),
            _buildProfileTile(Icons.help_outline, 'Support & FAQ', () => context.push('/customer-home/support')),
            _buildProfileTile(Icons.gavel_outlined, 'Terms of Service', () => _showLegal(context, 'Terms of Service')),
            _buildProfileTile(Icons.privacy_tip_outlined, 'Privacy Policy', () => _showLegal(context, 'Privacy Policy')),
            const Divider(height: 32),
            _buildProfileTile(Icons.logout, 'Logout', () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            }, isDestructive: true),
          ],
        ),
      ),
    );
  }

  void _showLegal(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LegalScreen(title: title)),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary),
      title: Text(title, style: TextStyle(color: isDestructive ? AppColors.error : AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
