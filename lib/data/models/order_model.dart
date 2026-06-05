enum OrderStatus {
  received,
  pickupAssigned,
  pickedUp,
  sorting,
  washing,
  drying,
  ironing,
  folding,
  packaging,
  qualityCheck,
  readyForDelivery,
  outForDelivery,
  delivered,
  completed,
  cancelled
}

class OrderModel {
  final String id;
  final String customerId;
  final String? branchId;
  final List<OrderItemModel> items;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final String? pickupAddress;
  final String? deliveryAddress;
  final String? notes;

  OrderModel({
    required this.id,
    required this.customerId,
    this.branchId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.pickupDate,
    this.deliveryDate,
    this.pickupAddress,
    this.deliveryAddress,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'branchId': branchId,
      'items': items.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'pickupDate': pickupDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      customerId: map['customerId'] ?? '',
      branchId: map['branchId'],
      items: List<OrderItemModel>.from(
        map['items']?.map((x) => OrderItemModel.fromMap(x)) ?? [],
      ),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.received,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      pickupDate: map['pickupDate'] != null ? DateTime.parse(map['pickupDate']) : null,
      deliveryDate: map['deliveryDate'] != null ? DateTime.parse(map['deliveryDate']) : null,
      pickupAddress: map['pickupAddress'],
      deliveryAddress: map['deliveryAddress'],
      notes: map['notes'],
    );
  }
}

class OrderItemModel {
  final String serviceId;
  final String categoryId;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.serviceId,
    required this.categoryId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'categoryId': categoryId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      serviceId: map['serviceId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}
