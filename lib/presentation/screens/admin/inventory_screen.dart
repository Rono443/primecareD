import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class InventoryItem {
  String id;
  String name;
  double qty;
  String unit;
  double lowThreshold;

  InventoryItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.unit,
    required this.lowThreshold,
  });
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<InventoryItem> _inventory = [
    InventoryItem(id: '1', name: 'Liquid Detergent', qty: 45, unit: 'L', lowThreshold: 10),
    InventoryItem(id: '2', name: 'Fabric Softener', qty: 20, unit: 'L', lowThreshold: 5),
    InventoryItem(id: '3', name: 'Stain Remover', qty: 8, unit: 'L', lowThreshold: 10),
  ];

  void _showItemDialog([InventoryItem? item]) {
    final nameController = TextEditingController(text: item?.name);
    final qtyController = TextEditingController(text: item?.qty.toString());
    final unitController = TextEditingController(text: item?.unit ?? 'L');
    final thresholdController = TextEditingController(text: item?.lowThreshold.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(item == null ? 'Add New Item' : 'Edit Item', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit (L, Kg, pcs)'))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: thresholdController, decoration: const InputDecoration(labelText: 'Low Stock Alert Level'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (item == null) {
                  _inventory.add(InventoryItem(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    qty: double.tryParse(qtyController.text) ?? 0,
                    unit: unitController.text,
                    lowThreshold: double.tryParse(thresholdController.text) ?? 0,
                  ));
                } else {
                  item.name = nameController.text;
                  item.qty = double.tryParse(qtyController.text) ?? 0;
                  item.unit = unitController.text;
                  item.lowThreshold = double.tryParse(thresholdController.text) ?? 0;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 45)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() => _inventory.removeWhere((i) => i.id == id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Inventory Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _inventory.length,
        itemBuilder: (context, index) {
          final item = _inventory[index];
          final bool isLow = item.qty <= item.lowThreshold;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isLow ? Colors.red : AppColors.primary).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(isLow ? Icons.warning_rounded : Icons.inventory_2_rounded, 
                           color: isLow ? Colors.red : AppColors.primary),
              ),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Status: ${isLow ? "Restock Needed" : "In Stock"}', 
                            style: TextStyle(color: isLow ? Colors.red : Colors.green, fontSize: 12)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${item.qty} ${item.unit}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 8),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                    onSelected: (val) {
                      if (val == 'edit') _showItemDialog(item);
                      if (val == 'delete') _deleteItem(item.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemDialog(),
        label: const Text('Add Stock'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.secondary,
      ),
    );
  }
}
