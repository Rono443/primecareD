import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderRepository {
  FirebaseFirestore? get _firestore {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      return null;
    }
  }

  // For demo/mock mode
  static final List<OrderModel> _mockOrders = [];

  Future<void> saveOrder(OrderModel order) async {
    final firestore = _firestore;
    if (firestore == null) {
      debugPrint('Firestore not available, saving to mock list');
      _mockOrders.add(order);
      return;
    }

    try {
      await firestore.collection('orders').doc(order.id).set(order.toMap());
    } catch (e) {
      debugPrint('Firestore save failed, saving to mock list: $e');
      _mockOrders.add(order);
    }
  }

  Stream<List<OrderModel>> getOrdersStream(String customerId) {
    final firestore = _firestore;
    if (firestore == null) {
      return Stream.value(_mockOrders.where((o) => o.customerId == customerId).toList());
    }

    try {
      return firestore
          .collection('orders')
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (e) {
      return Stream.value(_mockOrders.where((o) => o.customerId == customerId).toList());
    }
  }

  Stream<List<OrderModel>> getAllOrdersStream() {
    final firestore = _firestore;
    if (firestore == null) {
      return Stream.value(_mockOrders);
    }

    try {
      return firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList());
    } catch (e) {
      return Stream.value(_mockOrders);
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final firestore = _firestore;
    if (firestore == null) {
      final index = _mockOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _mockOrders[index] = _mockOrders[index].copyWith(status: status);
      }
      return;
    }

    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': status.name,
      });
    } catch (e) {
      final index = _mockOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _mockOrders[index] = _mockOrders[index].copyWith(status: status);
      }
    }
  }

  Future<void> updateOrderFields(String orderId, Map<String, dynamic> fields) async {
    final firestore = _firestore;
    if (firestore == null) return;

    try {
      await firestore.collection('orders').doc(orderId).update(fields);
    } catch (e) {
      debugPrint('Update fields failed: $e');
    }
  }

  Future<List<OrderModel>> loadOrders() async {
     final firestore = _firestore;
     if (firestore == null) return _mockOrders;

     try {
       final snapshot = await firestore.collection('orders').get();
       return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
     } catch (e) {
       return _mockOrders;
     }
  }
}
