import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = [
      {'name': 'Alice Wangari', 'role': 'Branch Manager', 'branch': 'Westlands'},
      {'name': 'David Mike', 'role': 'Delivery Rider', 'branch': 'Westlands'},
      {'name': 'Sarah Kemboi', 'role': 'Laundry Staff', 'branch': 'Kilimani'},
      {'name': 'Peter Kamau', 'role': 'Receptionist', 'branch': 'CBD Hub'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Staff Management')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: staff.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final s = staff[index];
          return ListTile(
            leading: CircleAvatar(child: Text(s['name']![0])),
            title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${s['role']} • ${s['branch']}'),
            trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add Staff'),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
