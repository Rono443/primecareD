import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = [
      {'name': 'Liquid Detergent', 'qty': 45, 'unit': 'L', 'low': 10},
      {'name': 'Fabric Softener', 'qty': 20, 'unit': 'L', 'low': 5},
      {'name': 'Stain Remover', 'qty': 8, 'unit': 'L', 'low': 10},
      {'name': 'Hangers', 'qty': 500, 'unit': 'pcs', 'low': 100},
      {'name': 'Laundry Bags', 'qty': 150, 'unit': 'pcs', 'low': 50},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: inventory.length,
        itemBuilder: (context, index) {
          final item = inventory[index];
          final bool isLow = (item['qty'] as int) <= (item['low'] as int);

          return Card(
            child: ListTile(
              leading: Icon(
                isLow ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                color: isLow ? AppColors.error : AppColors.primary,
              ),
              title: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Threshold: ${item['low']} ${item['unit']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item['qty']} ${item['unit']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isLow ? AppColors.error : AppColors.textPrimary,
                    ),
                  ),
                  if (isLow) const Text('LOW STOCK', style: TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
