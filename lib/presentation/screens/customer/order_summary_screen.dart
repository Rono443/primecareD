import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';

class OrderSummaryScreen extends ConsumerWidget {
  const OrderSummaryScreen({super.key});

  void _showDatePicker(BuildContext context, String type) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((date) {
      if (date != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$type date set to ${date.day}/${date.month}/${date.year}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final user = ref.watch(authProvider);

    final subtotal = cart.totalPrice;
    const deliveryFee = 200.0;
    final tax = subtotal * 0.16;
    final total = subtotal + deliveryFee + tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Pickup & Delivery'),
            _buildInfoCard(
              icon: Icons.location_on_outlined,
              title: 'Delivery Address',
              subtitle: user?.address ?? '123 Prime St, Nairobi, Kenya',
              onEdit: () {},
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Schedule Pickup',
              subtitle: 'Select your preferred time slot',
              onEdit: () => _showDatePicker(context, 'Pickup'),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.delivery_dining_outlined,
              title: 'Schedule Delivery',
              subtitle: 'Select return time slot',
              onEdit: () => _showDatePicker(context, 'Delivery'),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Order Details'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...cart.selectedItems.entries.map((entry) {
                      final item = cart.availableItems.firstWhere((i) => i['id'] == entry.key);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${entry.value}x ${item['name']}'),
                            Text('KES ${item['price'] * entry.value}'),
                          ],
                        ),
                      );
                    }).toList(),
                    const Divider(),
                    _PriceRow(label: 'Subtotal', value: 'KES ${subtotal.toStringAsFixed(0)}'),
                    const _PriceRow(label: 'Pickup & Delivery', value: 'KES 200'),
                    _PriceRow(label: 'Tax (16%)', value: 'KES ${tax.toStringAsFixed(0)}'),
                    const Divider(),
                    _PriceRow(label: 'Total', value: 'KES ${total.toStringAsFixed(0)}', isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Payment Method'),
            _buildPaymentSelection(),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login to place an order')),
                    );
                    return;
                  }

                  final orderItems = cart.selectedItems.entries.map((entry) {
                    final item = cart.availableItems.firstWhere((i) => i['id'] == entry.key);
                    return OrderItemModel(
                      serviceId: cart.selectedService?['id'] ?? '',
                      categoryId: item['category'] ?? '',
                      quantity: entry.value,
                      price: item['price'],
                    );
                  }).toList();

                  final newOrder = OrderModel(
                    id: 'PC-${DateTime.now().millisecondsSinceEpoch}',
                    customerId: user.id,
                    items: orderItems,
                    totalPrice: total,
                    status: OrderStatus.received,
                    createdAt: DateTime.now(),
                    pickupAddress: user.address ?? 'Default Address',
                    deliveryAddress: user.address ?? 'Default Address',
                  );

                  await ref.read(orderProvider.notifier).addOrder(newOrder);
                  ref.read(cartProvider.notifier).clear();
                  if (context.mounted) {
                    _showSuccessDialog(context, newOrder.id);
                  }
                },
                child: const Text('PLACE ORDER'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle, required VoidCallback onEdit}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, size: 20)),
        ],
      ),
    );
  }

  Widget _buildPaymentSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: const Row(
        children: [
          Icon(Icons.phone_android, color: AppColors.primary),
          SizedBox(width: 16),
          Text('M-Pesa (Daraja API)', style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.successGradient,
                shape: BoxShape.circle,
                boxShadow: AppColors.successGlow,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 32),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            const SizedBox(height: 12),
            Text(
              'Your order #$orderId has been successfully placed. Your clothes are in good hands!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/customer-home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('GO TO DASHBOARD'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          )),
          Text(value, style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          )),
        ],
      ),
    );
  }
}
