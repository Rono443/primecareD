import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class ItemSelectionScreen extends StatefulWidget {
  const ItemSelectionScreen({super.key});

  @override
  State<ItemSelectionScreen> createState() => _ItemSelectionScreenState();
}

class _ItemSelectionScreenState extends State<ItemSelectionScreen> {
  final Map<String, int> _selectedItems = {};
  
  final List<Map<String, dynamic>> _items = [
    {'name': 'Shirt', 'price': 150, 'category': 'Men'},
    {'name': 'Trousers', 'price': 200, 'category': 'Men'},
    {'name': 'Dress', 'price': 350, 'category': 'Women'},
    {'name': 'Suit (2pcs)', 'price': 800, 'category': 'Formal'},
    {'name': 'Duvet (Large)', 'price': 1200, 'category': 'Household'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Items')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final name = item['name'] as String;
                final count = _selectedItems[name] ?? 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('KES ${item['price']}', style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: count > 0 ? () => setState(() => _selectedItems[name] = count - 1) : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () => setState(() => _selectedItems[name] = count + 1),
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    int totalItems = _selectedItems.values.fold(0, (sum, count) => sum + count);
    double totalPrice = _selectedItems.entries.fold(0.0, (sum, entry) {
      final item = _items.firstWhere((i) => i['name'] == entry.key);
      return sum + (item['price'] * entry.value);
    });

    if (totalItems == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$totalItems Items Selected', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Total: KES $totalPrice', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/customer-home/order-summary'),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
