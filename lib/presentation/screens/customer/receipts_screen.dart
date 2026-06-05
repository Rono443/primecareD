import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Receipts')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.primary),
              title: Text('Receipt #INV-2023-00${index + 1}'),
              subtitle: Text('Date: 1${index + 1} Oct 2023 • KES ${850 + (index * 100)}'),
              trailing: const Icon(Icons.download_for_offline_outlined, color: AppColors.primary),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading receipt...')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
