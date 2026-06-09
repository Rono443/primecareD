enum UserRole {
  superAdmin,
  branchManager,
  receptionist,
  laundryStaff,
  deliveryRider,
  customer
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final UserRole role;
  final String? profilePicture;
  final String? branchId;
  final String? address;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.role,
    this.profilePicture,
    this.branchId,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'profilePicture': profilePicture,
      'branchId': branchId,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.customer,
      ),
      profilePicture: map['profilePicture'],
      branchId: map['branchId'],
      address: map['address'],
    );
  }
}
