import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String name;
  late String email;
  late String role;
  late List<dynamic> products;
  late int orders;
  late DateTime registerDate;
  late bool approved;
  late bool canAddParty;
  late bool canEditOrderStatus;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.products,
    required this.canAddParty,
    this.orders = 0,
    required this.registerDate,
    this.approved = false,
    this.canEditOrderStatus = false,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'] ?? '',
        name = data['name'] ?? '',
        email = data['email'] ?? '',
        role = data['role'] ?? '',
        products = data['products'] ?? [],
        canAddParty = data['canAddParty'] ?? false,
        orders = data['orders'] ?? 0,
        registerDate = (data['registerDate'] as Timestamp).toDate(),
        approved = data['approved'] ?? false,
        canEditOrderStatus = data['canEditOrderStatus'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'products': products,
      'canAddParty': canAddParty,
      'orders': orders,
      'registerDate': registerDate,
      'approved': approved,
      'canEditOrderStatus': canEditOrderStatus,
    };
  }
}
