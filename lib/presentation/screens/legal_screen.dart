import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  const LegalScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: November 2023',
              style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome to PrimeCare Laundry. We are committed to protecting your personal information and your right to privacy...',
            ),
            const SizedBox(height: 24),
            const Text(
              '2. Data Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We collect personal data that you provide to us such as name, address, contact information, passwords and security data...',
            ),
            // More sections...
          ],
        ),
      ),
    );
  }
}
