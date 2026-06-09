import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import 'auth_provider.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository());

final customerOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(orderRepositoryProvider).getOrdersStream(user.id);
});

final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderRepositoryProvider).getAllOrdersStream();
});

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

class CartState {
  final Map<String, dynamic>? selectedService;
  final Map<String, int> selectedItems;
  final List<Map<String, dynamic>> availableItems;

  CartState({
    this.selectedService,
    this.selectedItems = const {},
    this.availableItems = const [
      {'id': 'i1', 'name': 'Shirt', 'price': 150.0, 'category': 'Men'},
      {'id': 'i2', 'name': 'Trousers', 'price': 200.0, 'category': 'Men'},
      {'id': 'i3', 'name': 'Dress', 'price': 350.0, 'category': 'Women'},
      {'id': 'i4', 'name': 'Suit (2pcs)', 'price': 800.0, 'category': 'Formal'},
      {'id': 'i5', 'name': 'Duvet (Large)', 'price': 1200.0, 'category': 'Household'},
    ],
  });

  CartState copyWith({
    Map<String, dynamic>? selectedService,
    Map<String, int>? selectedItems,
  }) {
    return CartState(
      selectedService: selectedService ?? this.selectedService,
      selectedItems: selectedItems ?? this.selectedItems,
      availableItems: availableItems,
    );
  }

  double get totalPrice {
    return selectedItems.entries.fold(0.0, (sum, entry) {
      final item = availableItems.firstWhere((i) => i['id'] == entry.key);
      return sum + (item['price'] * entry.value);
    });
  }

  int get totalItems {
    return selectedItems.values.fold(0, (sum, count) => sum + count);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void setService(Map<String, dynamic> service) {
    state = state.copyWith(selectedService: service);
  }

  void updateItemQuantity(String itemId, int delta) {
    final currentQuantity = state.selectedItems[itemId] ?? 0;
    final newQuantity = currentQuantity + delta;
    
    final newItems = Map<String, int>.from(state.selectedItems);
    if (newQuantity <= 0) {
      newItems.remove(itemId);
    } else {
      newItems[itemId] = newQuantity;
    }
    
    state = state.copyWith(selectedItems: newItems);
  }

  void clear() {
    state = CartState();
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, List<OrderModel>>((ref) {
  return OrderNotifier(ref.watch(orderRepositoryProvider));
});

class OrderNotifier extends StateNotifier<List<OrderModel>> {
  final OrderRepository _repository;

  OrderNotifier(this._repository) : super([]);

  Future<void> addOrder(OrderModel order) async {
    await _repository.saveOrder(order);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _repository.updateOrderStatus(orderId, status);
  }

  Future<void> updateOrderProof(String orderId, {String? qrCode, String? photoUrl, bool isPickup = true}) async {
    final updates = <String, dynamic>{};
    if (qrCode != null) updates['qrCode'] = qrCode;
    if (photoUrl != null) {
      updates[isPickup ? 'pickupPhoto' : 'deliveryPhoto'] = photoUrl;
    }
    await _repository.updateOrderFields(orderId, updates);
  }
}
