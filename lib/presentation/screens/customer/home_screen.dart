import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/order_provider.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PrimeCare', style: TextStyle(letterSpacing: -0.5)),
            Text('Premium Laundry Solutions', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          _buildCircleAction(Icons.notifications_none_rounded, () {}),
          const SizedBox(width: 8),
          _buildCircleAction(Icons.person_outline_rounded, () => context.push('/customer-home/profile')),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildModernBalanceCard(context),
              const SizedBox(height: 24),
              _buildSectionHeader('Services', 'View All'),
              const SizedBox(height: 16),
              _buildModernServicesGrid(),
              const SizedBox(height: 32),
              _buildSectionHeader('Recent Orders', 'History'),
              const SizedBox(height: 16),
              _buildRecentOrders(context, ref),
              const SizedBox(height: 100), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/customer-home/service-selection'),
        label: const Text('Book New Laundry', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        TextButton(
          onPressed: () {},
          child: Text(action, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildModernBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('KES 42,450.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    _buildQuickAction(context, Icons.add_rounded, 'Top Up', () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('M-Pesa Top-up coming soon!')));
                    }),
                    const SizedBox(width: 12),
                    _buildQuickAction(context, Icons.qr_code_scanner_rounded, 'Pay', () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QR Scanner coming soon!')));
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildModernServicesGrid() {
    final services = [
      {'id': 's1', 'name': 'Wash & Fold', 'icon': Icons.local_laundry_service_rounded, 'color': Colors.blue, 'desc': 'Clean and neatly folded clothes.', 'price': '100/kg'},
      {'id': 's2', 'name': 'Wash & Iron', 'icon': Icons.iron_rounded, 'color': Colors.orange, 'desc': 'Wash, dry and professionally ironed.', 'price': '150/kg'},
      {'id': 's3', 'name': 'Dry Clean', 'icon': Icons.dry_cleaning_rounded, 'color': Colors.purple, 'desc': 'Special care for delicate fabrics.', 'price': '300/item'},
      {'id': 's4', 'name': 'Premium', 'icon': Icons.auto_awesome_rounded, 'color': Colors.amber, 'desc': 'White-glove service for luxury garments.', 'price': '500/item'},
    ];

    return Consumer(
      builder: (context, ref, child) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final color = service['color'] as Color;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(cartProvider.notifier).setService(service);
                  context.push('/customer-home/item-selection');
                },
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(service['icon'] as IconData, color: color, size: 28),
                      ),
                      Text(
                        service['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                ),
                title: Text(
                  'Order #${order.id.split('-').last.substring(0, 5)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${order.status.name.toUpperCase()} • ${order.totalPrice} KES',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                onTap: () => context.push('/customer-home/order-tracking/${order.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.layers_clear_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No active orders', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const Text('Your fresh clothes are a tap away!', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
