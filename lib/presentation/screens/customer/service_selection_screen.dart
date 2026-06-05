import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'id': '1', 'name': 'Wash & Fold', 'desc': 'Clean and neatly folded clothes.', 'price': '100/kg', 'icon': Icons.local_laundry_service},
      {'id': '2', 'name': 'Wash & Iron', 'desc': 'Wash, dry and professionally ironed.', 'price': '150/kg', 'icon': Icons.iron},
      {'id': '3', 'name': 'Dry Cleaning', 'desc': 'Special care for delicate fabrics.', 'price': '300/item', 'icon': Icons.dry_cleaning},
      {'id': '4', 'name': 'Iron Only', 'desc': 'Just professional pressing.', 'price': '50/item', 'icon': Icons.check_circle_outline},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Service')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(service['icon'] as IconData, color: AppColors.primary),
              ),
              title: Text(service['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service['desc'] as String),
                  const SizedBox(height: 4),
                  Text(
                    'Starts from ${service['price']}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/customer-home/item-selection'),
            ),
          );
        },
      ),
    );
  }
}
