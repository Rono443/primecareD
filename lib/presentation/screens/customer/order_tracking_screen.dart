import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/feedback_widget.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order #PC-9823')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 32),
            _buildTimeline(),
            const SizedBox(height: 32),
            _buildRiderInfo(),
            const SizedBox(height: 32),
            if (steps.last['done'] as bool)
              ElevatedButton.icon(
                onPressed: () => _showFeedbackSheet(context),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('RATE SERVICE'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              ),
          ],
        ),
      ),
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

  static const steps = [
    {'title': 'Order Placed', 'time': 'Mon, 10:00 AM', 'done': true},
    {'title': 'Picked Up', 'time': 'Mon, 2:30 PM', 'done': true},
    {'title': 'In Laundry', 'time': 'Tue, 9:00 AM', 'done': true},
    {'title': 'Ready for Delivery', 'time': 'Expected Thu', 'done': true},
    {'title': 'Delivered', 'time': 'Expected Fri', 'done': true},
  ];

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping, size: 40, color: AppColors.primary),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Washing in progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Estimated delivery: Friday, 4 PM', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: steps.map((step) {
        int index = steps.indexOf(step);
        bool isLast = index == steps.length - 1;
        bool isDone = step['done'] as bool;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? AppColors.primary : Colors.grey.shade300,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50,
                    color: isDone ? AppColors.primary : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title'] as String,
                    style: TextStyle(
                      fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                      color: isDone ? AppColors.textPrimary : Colors.grey,
                    ),
                  ),
                  Text(step['time'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRiderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://via.placeholder.com/100')),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rider: David Mike', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('4.8 ★ Rating', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: AppColors.success),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
