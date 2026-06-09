import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../widgets/feedback_widget.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Track Order #${orderId.split('-').last.substring(0, 5)}'),
      ),
      body: ordersAsync.when(
        data: (orders) {
          final order = orders.firstWhere((o) => o.id == orderId, orElse: () => throw 'Order not found');
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildStatusBanner(order),
                const SizedBox(height: 32),
                _buildTimeline(order),
                const SizedBox(height: 32),
                _buildRiderCard(),
                const SizedBox(height: 40),
                if (order.status == OrderStatus.completed)
                  _buildRateButton(context),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatusBanner(OrderModel order) {
    LinearGradient bgGradient;
    IconData statusIcon;
    List<BoxShadow> glow;

    switch (order.status) {
      case OrderStatus.completed:
      case OrderStatus.delivered:
        bgGradient = AppColors.successGradient;
        statusIcon = Icons.check_circle_rounded;
        glow = AppColors.successGlow;
        break;
      case OrderStatus.cancelled:
        bgGradient = const LinearGradient(colors: [Colors.redAccent, Colors.red]);
        statusIcon = Icons.cancel_rounded;
        glow = [BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 20)];
        break;
      default:
        bgGradient = AppColors.primaryGradient;
        statusIcon = Icons.local_shipping_rounded;
        glow = AppColors.softGlow;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: glow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.status.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                Text(
                  'Your laundry is being handled with care.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(OrderModel order) {
    final currentStatusIndex = order.status.index;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: OrderStatus.values.take(currentStatusIndex + 2).map((status) {
          bool isDone = status.index <= currentStatusIndex;
          bool isCurrent = status.index == currentStatusIndex;
          bool isLast = status == OrderStatus.values.last || status.index == currentStatusIndex + 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppColors.primary : Colors.grey.shade200,
                        boxShadow: isCurrent ? AppColors.softGlow : null,
                      ),
                      child: Icon(
                        isDone ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
                        size: 16,
                        color: isDone ? Colors.white : Colors.grey,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isDone ? AppColors.primary : Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusLabel(status),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                          color: isDone ? AppColors.textPrimary : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isDone ? 'Action completed' : 'Coming up next',
                        style: TextStyle(fontSize: 12, color: isDone ? AppColors.textSecondary : AppColors.textLight),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.received: return "Order Confirmed";
      case OrderStatus.pickupAssigned: return "Rider Assigned";
      case OrderStatus.pickedUp: return "Picked Up";
      case OrderStatus.washing: return "Cleaning in Progress";
      case OrderStatus.readyForDelivery: return "Ready for Return";
      case OrderStatus.delivered: return "Successfully Delivered";
      default: return status.name.toUpperCase();
    }
  }

  Widget _buildRiderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.background,
            child: Icon(Icons.person_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('David Mike', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Dedicated Delivery Partner', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          _buildCircleIcon(Icons.phone_rounded, AppColors.success),
          const SizedBox(width: 8),
          _buildCircleIcon(Icons.chat_bubble_rounded, AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildRateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showFeedbackSheet(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        shadowColor: AppColors.success.withOpacity(0.3),
        elevation: 8,
      ),
      child: const Text('RATE YOUR EXPERIENCE'),
    );
  }

  void _showFeedbackSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const FeedbackWidget(),
      ),
    );
  }
}
