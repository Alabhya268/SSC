import 'package:cloud_firestore/cloud_firestore.dart';

class PartiesModel {
  late String id;
  late String name;
  late String location;
  late String product;
  late double limit;
  DateTime registrationDate = DateTime.now();

  PartiesModel({
    this.id = '',
    required this.name,
    required this.location,
    required this.limit,
    required this.product,
  });

  PartiesModel.fromData(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        location = data['location'] ?? '',
        product = data['product'] ?? '',
        limit = data['limit'].toDouble() ?? 0,
        registrationDate = (data['registrationDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'limit': limit,
      'product': product,
      'registrationDate': registrationDate,
    };
  }
}
