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
  final String? qrCode;
  final String? pickupPhoto;
  final String? deliveryPhoto;
  final Map<String, dynamic>? metadata; // For AI analytics (weight, machine used)

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
    this.qrCode,
    this.pickupPhoto,
    this.deliveryPhoto,
    this.metadata,
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
      'qrCode': qrCode,
      'pickupPhoto': pickupPhoto,
      'deliveryPhoto': deliveryPhoto,
      'metadata': metadata,
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
      qrCode: map['qrCode'],
      pickupPhoto: map['pickupPhoto'],
      deliveryPhoto: map['deliveryPhoto'],
      metadata: map['metadata'],
    );
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? branchId,
    List<OrderItemModel>? items,
    double? totalPrice,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? pickupDate,
    DateTime? deliveryDate,
    String? pickupAddress,
    String? deliveryAddress,
    String? notes,
    String? qrCode,
    String? pickupPhoto,
    String? deliveryPhoto,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      branchId: branchId ?? this.branchId,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      pickupDate: pickupDate ?? this.pickupDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      notes: notes ?? this.notes,
      qrCode: qrCode ?? this.qrCode,
      pickupPhoto: pickupPhoto ?? this.pickupPhoto,
      deliveryPhoto: deliveryPhoto ?? this.deliveryPhoto,
      metadata: metadata ?? this.metadata,
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
