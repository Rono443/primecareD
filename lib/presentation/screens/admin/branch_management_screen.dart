import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class Branch {
  String id;
  String name;
  String location;
  String manager;
  int machineCount;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.manager,
    required this.machineCount,
  });
}

class BranchManagementScreen extends StatefulWidget {
  const BranchManagementScreen({super.key});

  @override
  State<BranchManagementScreen> createState() => _BranchManagementScreenState();
}

class _BranchManagementScreenState extends State<BranchManagementScreen> {
  final List<Branch> _branches = [
    Branch(id: '1', name: 'Westlands Hub', location: 'Waiyaki Way', manager: 'Alice Wangari', machineCount: 12),
    Branch(id: '2', name: 'Kilimani Point', location: 'Argwings Kodhek', manager: 'Sarah Kemboi', machineCount: 8),
    Branch(id: '3', name: 'CBD Central', location: 'Kenyatta Ave', manager: 'Peter Kamau', machineCount: 15),
  ];

  void _showBranchDialog([Branch? branch]) {
    final nameController = TextEditingController(text: branch?.name);
    final locController = TextEditingController(text: branch?.location);
    final managerController = TextEditingController(text: branch?.manager);
    final machineController = TextEditingController(text: branch?.machineCount.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(branch == null ? 'Add New Branch' : 'Edit Branch'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Branch Name')),
              const SizedBox(height: 12),
              TextField(controller: locController, decoration: const InputDecoration(labelText: 'Location')),
              const SizedBox(height: 12),
              TextField(controller: managerController, decoration: const InputDecoration(labelText: 'Manager Name')),
              const SizedBox(height: 12),
              TextField(controller: machineController, decoration: const InputDecoration(labelText: 'Machine Count'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (branch == null) {
                  _branches.add(Branch(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    location: locController.text,
                    manager: managerController.text,
                    machineCount: int.tryParse(machineController.text) ?? 0,
                  ));
                } else {
                  branch.name = nameController.text;
                  branch.location = locController.text;
                  branch.manager = managerController.text;
                  branch.machineCount = int.tryParse(machineController.text) ?? 0;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteBranch(String id) {
    setState(() => _branches.removeWhere((b) => b.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Branch Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _branches.length,
        itemBuilder: (context, index) {
          final b = _branches[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.storefront_rounded, color: AppColors.primary),
              ),
              title: Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.location, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(b.manager, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.settings, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${b.machineCount} Machines', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                onSelected: (val) {
                  if (val == 'edit') _showBranchDialog(b);
                  if (val == 'delete') _deleteBranch(b.id);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBranchDialog(),
        label: const Text('New Branch'),
        icon: const Icon(Icons.add_business_rounded),
        backgroundColor: AppColors.secondary,
      ),
    );
  }
}
