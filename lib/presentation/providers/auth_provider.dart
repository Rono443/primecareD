import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null);

  void login(String email, String password) {
    // Mock login logic
    if (email.contains('admin')) {
      state = UserModel(id: '1', email: email, name: 'Admin User', role: UserRole.superAdmin);
    } else if (email.contains('staff')) {
      state = UserModel(id: '2', email: email, name: 'Staff User', role: UserRole.laundryStaff);
    } else if (email.contains('rider')) {
      state = UserModel(id: '3', email: email, name: 'Rider User', role: UserRole.deliveryRider);
    } else {
      state = UserModel(id: '4', email: email, name: 'Customer User', role: UserRole.customer);
    }
  }

  void logout() {
    state = null;
  }
}
