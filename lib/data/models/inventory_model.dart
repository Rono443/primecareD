class InventoryModel {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final int lowStockThreshold;
  final String? branchId;

  InventoryModel({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.lowStockThreshold,
    this.branchId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'lowStockThreshold': lowStockThreshold,
      'branchId': branchId,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? '',
      lowStockThreshold: map['lowStockThreshold'] ?? 5,
      branchId: map['branchId'],
    );
  }
}
