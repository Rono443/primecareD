import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../../providers/order_provider.dart';

class RiderHomeScreen extends ConsumerWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        final pickups = orders.where((o) => o.status == OrderStatus.received).toList();
        final deliveries = orders.where((o) => o.status == OrderStatus.readyForDelivery).toList();

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rider Dashboard', style: TextStyle(fontSize: 18)),
                  Text('Online • Optimized Route', style: TextStyle(fontSize: 12, color: Colors.greenAccent)),
                ],
              ),
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Pickups (${pickups.length})'),
                  Tab(text: 'Deliveries (${deliveries.length})'),
                  const Tab(text: 'My Earnings'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildTaskList(context, ref, pickups, true),
                _buildTaskList(context, ref, deliveries, false),
                _buildEarningsView(),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildTaskList(BuildContext context, WidgetRef ref, List<OrderModel> orders, bool isPickup) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(isPickup ? 'All pickups completed!' : 'No pending deliveries'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final bool hasQr = order.qrCode != null;
        final bool hasPhoto = isPickup ? order.pickupPhoto != null : order.deliveryPhoto != null;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ORDER #${order.id.split('-').last.substring(0, 5)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('1.2 km away', style: TextStyle(fontSize: 10, color: Colors.blue)),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.person, order.customerId),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, isPickup ? (order.pickupAddress ?? 'N/A') : (order.deliveryAddress ?? 'N/A')),
                const SizedBox(height: 20),
                
                // Intelligent Checklist
                const Text('Required Actions:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildCheckItem('Scan Tag', hasQr),
                    const SizedBox(width: 16),
                    _buildCheckItem('Photo Proof', hasPhoto),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Navigate'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (hasQr && hasPhoto) 
                          ? () => _handleStatusUpdate(ref, order, isPickup)
                          : () => _showActionSheet(context, ref, order, isPickup),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (hasQr && hasPhoto) ? AppColors.success : AppColors.primary,
                        ),
                        child: Text(isPickup ? ( (hasQr && hasPhoto) ? 'Confirm Pickup' : 'Start Pickup') : 'Complete Delivery'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  Widget _buildCheckItem(String label, bool isDone) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isDone ? Icons.check_circle : Icons.circle_outlined, 
             size: 16, color: isDone ? Colors.green : Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: isDone ? Colors.green : Colors.grey)),
      ],
    );
  }

  void _showActionSheet(BuildContext context, WidgetRef ref, OrderModel order, bool isPickup) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Complete Required Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
              title: const Text('Scan Bag Tag'),
              subtitle: const Text('Ensure correct order identification'),
              trailing: order.qrCode != null ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () {
                ref.read(orderProvider.notifier).updateOrderProof(order.id, qrCode: 'TAG-${order.id.substring(0,5)}');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take Condition Photo'),
              subtitle: const Text('Protect against liability claims'),
              trailing: (isPickup ? order.pickupPhoto : order.deliveryPhoto) != null ? const Icon(Icons.check_circle, color: Colors.green) : null,
              onTap: () {
                ref.read(orderProvider.notifier).updateOrderProof(order.id, photoUrl: 'https://proof.url', isPickup: isPickup);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStatusUpdate(WidgetRef ref, OrderModel order, bool isPickup) async {
    final nextStatus = isPickup ? OrderStatus.pickedUp : OrderStatus.delivered;
    await ref.read(orderProvider.notifier).updateOrderStatus(order.id, nextStatus);
  }

  Widget _buildEarningsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)]),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Payout', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                Text('KES 2,450.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                Divider(color: Colors.white24, height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Completed Jobs: 12', style: TextStyle(color: Colors.white)),
                    Text('Points: 450 pts', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Recent Payout History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildEarningTile('Mon, 22 Jan', '8 Jobs', '1,600'),
          _buildEarningTile('Sun, 21 Jan', '15 Jobs', '3,200'),
          _buildEarningTile('Sat, 20 Jan', '10 Jobs', '2,100'),
        ],
      ),
    );
  }

  Widget _buildEarningTile(String date, String jobs, String amount) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.blueGrey, child: Icon(Icons.history, color: Colors.white)),
      title: Text(date),
      subtitle: Text(jobs),
      trailing: Text('KES $amount', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
    );
  }
}
