import 'package:cloud_firestore/cloud_firestore.dart';

class PartiesModel {
  late String id;
  late String name;
  late String location;
  late String product;
  late double limit;
  DateTime registrationDate = DateTime.now();

  PartiesModel({
    required this.name,
    required this.location,
    required this.limit,
    required this.product,
  });

  PartiesModel.fromData(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        location = data['location'] ?? '',
        product = data['product'] ?? '',
        registrationDate = (data['registrationDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'product': product,
      'registrationDate': registrationDate,
    };
  }
}
