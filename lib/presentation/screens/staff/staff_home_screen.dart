import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../../providers/order_provider.dart';

class StaffHomeScreen extends ConsumerWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner)),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          final inProgressOrders = orders.where((o) => 
            o.status != OrderStatus.completed && 
            o.status != OrderStatus.cancelled &&
            o.status != OrderStatus.received &&
            o.status != OrderStatus.pickedUp
          ).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsRow(orders),
                const SizedBox(height: 24),
                const Text(
                  'Active Processing',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildAssignedOrdersList(inProgressOrders, ref)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatsRow(List<OrderModel> orders) {
    int washing = orders.where((o) => o.status == OrderStatus.washing).length;
    int drying = orders.where((o) => o.status == OrderStatus.drying).length;
    int ready = orders.where((o) => o.status == OrderStatus.readyForDelivery).length;

    return Row(
      children: [
        _buildStatBox('Washing', '$washing', Colors.blue),
        const SizedBox(width: 12),
        _buildStatBox('Drying', '$drying', Colors.orange),
        const SizedBox(width: 12),
        _buildStatBox('Ready', '$ready', Colors.green),
      ],
    );
  }

  Widget _buildStatBox(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedOrdersList(List<OrderModel> orders, WidgetRef ref) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders currently in processing.'));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: const CircleAvatar(child: Icon(Icons.local_laundry_service)),
            title: Text('Order #${order.id.split('-').last.substring(0, 5)}'),
            subtitle: Text('Status: ${order.status.name.toUpperCase()}'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatusStep('Sorting', _isStatusAfter(order.status, OrderStatus.sorting)),
                    _buildStatusStep('Washing', _isStatusAfter(order.status, OrderStatus.washing)),
                    _buildStatusStep('Drying', _isStatusAfter(order.status, OrderStatus.drying)),
                    _buildStatusStep('Ironing', _isStatusAfter(order.status, OrderStatus.ironing)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Add Note'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _showStatusUpdateDialog(context, ref, order),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(120, 40)),
                          child: const Text('Update Status'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isStatusAfter(OrderStatus current, OrderStatus target) {
    return current.index >= target.index;
  }

  Widget _buildStatusStep(String title, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppColors.success : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isCompleted ? AppColors.textPrimary : Colors.grey,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _showStatusUpdateDialog(BuildContext context, WidgetRef ref, OrderModel order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final statuses = OrderStatus.values.where((s) => s.index > order.status.index).toList();
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Update Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: statuses.length,
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    return ListTile(
                      title: Text(status.name.toUpperCase()),
                      onTap: () {
                        ref.read(orderProvider.notifier).updateOrderStatus(order.id, status);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
