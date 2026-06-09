import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/order_provider.dart';
import 'package:intl/intl.dart';

class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Receipts')),
      body: ordersAsync.when(
        data: (orders) {
          final completedOrders = orders.where((o) => o.status.name == 'delivered' || o.status.name == 'received').toList();
          
          if (completedOrders.isEmpty) {
            return const Center(child: Text('No receipts available yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedOrders.length,
            itemBuilder: (context, index) {
              final order = completedOrders[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                  title: Text('Receipt #${order.id.split('-').last.toUpperCase()}'),
                  subtitle: Text('Date: ${DateFormat('dd MMM yyyy').format(order.createdAt)} • KES ${order.totalPrice.toStringAsFixed(0)}'),
                  trailing: const Icon(Icons.download_for_offline_outlined, color: AppColors.primary),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading receipt...')),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading receipts')),
      ),
    );
  }
}
