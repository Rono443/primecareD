import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BranchManagementScreen extends StatelessWidget {
  const BranchManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final branches = [
      {'name': 'Main Branch - Westlands', 'manager': 'Alice Wangari', 'status': 'Active'},
      {'name': 'Kilimani Outlet', 'manager': 'Bob Otieno', 'status': 'Active'},
      {'name': 'CBD Hub', 'manager': 'Charlie Maina', 'status': 'Inactive'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Branches')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final branch = branches[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.store, color: Colors.white)),
              title: Text(branch['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Manager: ${branch['manager']}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: branch['status'] == 'Active' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  branch['status'] as String,
                  style: TextStyle(color: branch['status'] == 'Active' ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}
