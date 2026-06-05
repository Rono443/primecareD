import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../legal_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 16),
            const Text('Jane Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('jane.doe@example.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildProfileTile(Icons.person_outline, 'Edit Profile', () {}),
            _buildProfileTile(Icons.location_on_outlined, 'Manage Addresses', () {}),
            _buildProfileTile(Icons.payment_outlined, 'Payment Methods', () {}),
            _buildProfileTile(Icons.notifications_outlined, 'Notification Preferences', () {}),
            _buildProfileTile(Icons.help_outline, 'Support & FAQ', () => context.push('/customer-home/support')),
            _buildProfileTile(Icons.gavel_outlined, 'Terms of Service', () => _showLegal(context, 'Terms of Service')),
            _buildProfileTile(Icons.privacy_tip_outlined, 'Privacy Policy', () => _showLegal(context, 'Privacy Policy')),
            const Divider(height: 32),
            _buildProfileTile(Icons.logout, 'Logout', () => context.go('/login'), isDestructive: true),
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
