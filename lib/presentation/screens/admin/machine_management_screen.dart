import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/machine_model.dart';

class MachineManagementScreen extends StatelessWidget {
  const MachineManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final machines = [
      MachineModel(id: '1', name: 'Washer 01', type: 'LG Heavy Duty', status: MachineStatus.running, capacityKg: 15, currentOrderId: 'PC-9823'),
      MachineModel(id: '2', name: 'Washer 02', type: 'Samsung Pro', status: MachineStatus.idle, capacityKg: 10),
      MachineModel(id: '3', name: 'Dryer 01', type: 'Whirlpool XL', status: MachineStatus.maintenance, capacityKg: 20),
      MachineModel(id: '4', name: 'Dryer 02', type: 'Whirlpool XL', status: MachineStatus.running, capacityKg: 20, currentOrderId: 'PC-9824'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Machine Operations')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: machines.length,
        itemBuilder: (context, index) {
          final machine = machines[index];
          return _buildMachineCard(machine);
        },
      ),
    );
  }

  Widget _buildMachineCard(MachineModel machine) {
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
            const SizedBox(height: 16),
            Text(machine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(machine.type, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const Spacer(),
            if (machine.status == MachineStatus.running) ...[
              const Text('Active Order:', style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text(machine.currentOrderId ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ] else ...[
              Text(machine.status.name.toUpperCase(), style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: machine.status == MachineStatus.running ? 0.6 : 0,
                backgroundColor: Colors.grey.shade200,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
