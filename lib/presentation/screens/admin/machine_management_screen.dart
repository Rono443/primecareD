import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/machine_model.dart';

class MachineManagementScreen extends StatefulWidget {
  const MachineManagementScreen({super.key});

  @override
  State<MachineManagementScreen> createState() => _MachineManagementScreenState();
}

class _MachineManagementScreenState extends State<MachineManagementScreen> {
  final List<MachineModel> _machines = [
    MachineModel(id: '1', name: 'Washer 01', type: 'LG Heavy Duty', status: MachineStatus.running, capacityKg: 15, currentOrderId: 'PC-9823', totalCycles: 485),
    MachineModel(id: '2', name: 'Washer 02', type: 'Samsung Pro', status: MachineStatus.idle, capacityKg: 10, totalCycles: 120),
    MachineModel(id: '3', name: 'Dryer 01', type: 'Whirlpool XL', status: MachineStatus.maintenance, capacityKg: 20, totalCycles: 510),
    MachineModel(id: '4', name: 'Dryer 02', type: 'Whirlpool XL', status: MachineStatus.running, capacityKg: 20, currentOrderId: 'PC-9824', totalCycles: 300),
  ];

  void _showMachineDialog([MachineModel? machine]) {
    final nameController = TextEditingController(text: machine?.name);
    final typeController = TextEditingController(text: machine?.type);
    final capacityController = TextEditingController(text: machine?.capacityKg.toString());
    MachineStatus selectedStatus = machine?.status ?? MachineStatus.idle;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(machine == null ? 'Register Machine' : 'Edit Machine', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Machine Name (e.g. Washer 05)')),
                const SizedBox(height: 12),
                TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Model/Type')),
                const SizedBox(height: 12),
                TextField(controller: capacityController, decoration: const InputDecoration(labelText: 'Capacity (Kg)'), keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                DropdownButtonFormField<MachineStatus>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: MachineStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))).toList(),
                  onChanged: (val) => setDialogState(() => selectedStatus = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (machine == null) {
                    _machines.add(MachineModel(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      type: typeController.text,
                      capacityKg: double.tryParse(capacityController.text) ?? 0,
                      status: selectedStatus,
                    ));
                  } else {
                    // machine properties in model are likely final, 
                    // check machine_model.dart before assuming mutability.
                    // Assuming for now they can be updated or we replace the object
                    final index = _machines.indexWhere((m) => m.id == machine.id);
                    _machines[index] = MachineModel(
                      id: machine.id,
                      name: nameController.text,
                      type: typeController.text,
                      capacityKg: double.tryParse(capacityController.text) ?? 0,
                      status: selectedStatus,
                      totalCycles: machine.totalCycles,
                      currentOrderId: machine.currentOrderId,
                    );
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Machine Intelligence')),
      body: Column(
        children: [
          _buildHealthOverview(_machines),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _machines.length,
              itemBuilder: (context, index) {
                final machine = _machines[index];
                return GestureDetector(
                  onLongPress: () => _showMachineDialog(machine),
                  child: _buildMachineCard(context, machine),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMachineDialog(),
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHealthOverview(List<MachineModel> machines) {
    final maintenanceNeeded = machines.where((m) => m.needsMaintenance).length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.analytics_outlined, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Predictive Maintenance', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('$maintenanceNeeded machine(s) require attention soon', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (maintenanceNeeded > 0)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12)),
              child: const Text('SCHEDULE', style: TextStyle(fontSize: 10)),
            ),
        ],
      ),
    );
  }

  Widget _buildMachineCard(BuildContext context, MachineModel machine) {
    Color statusColor;
    switch (machine.status) {
      case MachineStatus.running: statusColor = Colors.blue; break;
      case MachineStatus.idle: statusColor = Colors.green; break;
      case MachineStatus.maintenance: statusColor = Colors.orange; break;
      case MachineStatus.error: statusColor = Colors.red; break;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(machine.type.contains('Washer') ? Icons.local_laundry_service : Icons.wb_sunny, color: AppColors.primary),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(machine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(machine.type, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            const Divider(height: 24),
            
            // Intelligence Data
            const Text('Mechanical Health', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: machine.healthPercentage,
                backgroundColor: Colors.grey.shade200,
                color: machine.healthPercentage < 0.2 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text('${machine.totalCycles}/${machine.maintenanceThreshold} cycles', style: const TextStyle(fontSize: 9, color: Colors.grey)),
            
            const Spacer(),
            if (machine.needsMaintenance)
              const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 14),
                  SizedBox(width: 4),
                  Text('Service Due', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              )
            else if (machine.status == MachineStatus.running)
              Text(machine.currentOrderId ?? 'Processing...', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12))
            else
              Text(machine.status.name.toUpperCase(), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
