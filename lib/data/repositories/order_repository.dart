import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // For demo/mock mode
  final List<OrderModel> _mockOrders = [];

  Future<void> saveOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
    } catch (e) {
      print('Firestore save failed, saving to mock list: $e');
      _mockOrders.add(order);
    }
  }

  Stream<List<OrderModel>> getOrdersStream(String customerId) {
    try {
      return _firestore
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
    try {
      return _firestore
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
    try {
      await _firestore.collection('orders').doc(orderId).update({
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
    try {
      await _firestore.collection('orders').doc(orderId).update(fields);
    } catch (e) {
      // Mock update not fully implemented for all fields
    }
  }

  Future<List<OrderModel>> loadOrders() async {
     // For legacy support or initial load if needed
     final snapshot = await _firestore.collection('orders').get();
     return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
  }
}
