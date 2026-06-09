import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/order_provider.dart';

class ItemSelectionScreen extends ConsumerWidget {
  const ItemSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(cart.selectedService?['name'] ?? 'Add Items'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.availableItems.length,
              itemBuilder: (context, index) {
                final item = cart.availableItems[index];
                final itemId = item['id'] as String;
                final count = cart.selectedItems[itemId] ?? 0;

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
                              Text(item['name'] as String, 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('KES ${item['price']}', 
                                style: const TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: count > 0 
                                ? () => ref.read(cartProvider.notifier).updateItemQuantity(itemId, -1) 
                                : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () => ref.read(cartProvider.notifier).updateItemQuantity(itemId, 1),
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
          _buildBottomSummary(context, ref, cart),
        ],
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, WidgetRef ref, CartState cart) {
    if (cart.totalItems == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${cart.totalItems} Items Selected', 
                  style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Total: KES ${cart.totalPrice}', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
