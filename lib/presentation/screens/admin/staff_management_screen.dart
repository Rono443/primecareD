import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class StaffMember {
  String id;
  String name;
  String role;
  String branch;
  bool isActive;

  StaffMember({
    required this.id,
    required this.name,
    required this.role,
    required this.branch,
    this.isActive = true,
  });
}

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final List<StaffMember> _staffList = [
    StaffMember(id: '1', name: 'Alice Wangari', role: 'Branch Manager', branch: 'Westlands'),
    StaffMember(id: '2', name: 'David Mike', role: 'Delivery Rider', branch: 'Westlands'),
    StaffMember(id: '3', name: 'Sarah Kemboi', role: 'Laundry Staff', branch: 'Kilimani'),
  ];

  final List<String> _roles = ['Branch Manager', 'Laundry Staff', 'Delivery Rider', 'Receptionist'];
  final List<String> _branches = ['Westlands', 'Kilimani', 'CBD Hub', 'Karen'];

  void _showStaffDialog([StaffMember? member]) {
    final nameController = TextEditingController(text: member?.name);
    String selectedRole = member?.role ?? _roles[1];
    String selectedBranch = member?.branch ?? _branches[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(member == null ? 'Register New Staff' : 'Edit Staff Details', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Job Role'),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) => setDialogState(() => selectedRole = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedBranch,
                  decoration: const InputDecoration(labelText: 'Assigned Branch'),
                  items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (val) => setDialogState(() => selectedBranch = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (member == null) {
                    _staffList.add(StaffMember(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      role: selectedRole,
                      branch: selectedBranch,
                    ));
                  } else {
                    member.name = nameController.text;
                    member.role = selectedRole;
                    member.branch = selectedBranch;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save Staff'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteStaff(String id) {
    setState(() => _staffList.removeWhere((s) => s.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Staff Directory')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _staffList.length,
        itemBuilder: (context, index) {
          final s = _staffList[index];
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
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(s.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.role, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(s.branch, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) {
                  if (val == 'edit') _showStaffDialog(s);
                  if (val == 'delete') _deleteStaff(s.id);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')])),
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_forever, size: 18, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStaffDialog(),
        label: const Text('Add Staff'),
        icon: const Icon(Icons.person_add_rounded),
        backgroundColor: AppColors.secondary,
      ),
    );
  }
}
