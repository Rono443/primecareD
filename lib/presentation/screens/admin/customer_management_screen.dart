import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Customer {
  final String id;
  final String name;
  final String email;
  final int totalOrders;
  final double totalSpent;
  final bool isVip;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.isVip = false,
  });
}

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final List<Customer> _customers = [
    Customer(id: '1', name: 'John Doe', email: 'john@example.com', totalOrders: 15, totalSpent: 24500, isVip: true),
    Customer(id: '2', name: 'Jane Smith', email: 'jane@smith.me', totalOrders: 8, totalSpent: 12000),
    Customer(id: '3', name: 'Alex Mwangi', email: 'alex.m@provider.com', totalOrders: 3, totalSpent: 4500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Customer Relationships')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final c = _customers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: (c.isVip ? Colors.amber : AppColors.primary).withOpacity(0.1),
                child: Icon(c.isVip ? Icons.workspace_premium : Icons.person, color: c.isVip ? Colors.amber.shade800 : AppColors.primary),
              ),
              title: Row(
                children: [
                  Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (c.isVip) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                      child: const Text('VIP', style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              subtitle: Text(c.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('KES ${c.totalSpent.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('${c.totalOrders} orders', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
