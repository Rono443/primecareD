import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactCard(Icons.chat_bubble_outline, 'Live Chat', 'Chat with our support team', () {}),
            _buildContactCard(Icons.phone_outlined, 'Call Us', '+254 700 000 000', () {}),
            _buildContactCard(Icons.email_outlined, 'Email Support', 'support@primecare.com', () {}),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            _buildFAQTile('How long does standard laundry take?', 'Standard laundry takes 24-48 hours.'),
            _buildFAQTile('How do I track my order?', 'You can track your order from the home dashboard under "Recent Orders".'),
            _buildFAQTile('Can I schedule a specific pickup time?', 'Yes, during the order process you can select your preferred pickup and delivery slots.'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer, style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
