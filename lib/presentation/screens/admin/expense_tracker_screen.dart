import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ExpenseTrackerScreen extends StatelessWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = [
      {'title': 'Electricity Bill', 'cat': 'Utilities', 'amt': 15000, 'date': 'Oct 28'},
      {'title': 'Detergent Restock', 'cat': 'Supplies', 'amt': 8500, 'date': 'Oct 26'},
      {'title': 'Rent - Westlands', 'cat': 'Fixed', 'amt': 120000, 'date': 'Oct 01'},
      {'title': 'Machine Repair', 'cat': 'Maintenance', 'amt': 4200, 'date': 'Oct 15'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final ex = expenses[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      child: const Icon(Icons.arrow_outward, color: Colors.red, size: 20),
                    ),
                    title: Text(ex['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${ex['cat']} • ${ex['date']}'),
                    trailing: Text(
                      'KES ${ex['amt']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Log Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Expenses (Oct)', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 8),
              Text('KES 147,700', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.analytics_outlined, color: Colors.white38, size: 40),
        ],
      ),
    );
  }
}
