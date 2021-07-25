import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  late String id;
  late String uid;
  late String partyId;
  late String product;
  late double perUnitAmount;
  late double numberOfUnits;
  late String status;
  late String description;
  late bool billed;
  late double tax;
  late double extraCharges;
  DateTime issueDate = DateTime.now();
  DateTime statusDate = DateTime.now();

  OrdersModel({
    required this.uid,
    required this.partyId,
    required this.product,
    required this.perUnitAmount,
    required this.numberOfUnits,
    required this.status,
    required this.description,
    required this.billed,
    required this.tax,
    required this.extraCharges,
    required this.issueDate,
    required this.statusDate,
  });

  OrdersModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'] ?? '',
        partyId = data['partyId'] ?? '',
        product = data['product'] ?? '',
        perUnitAmount = data['perUnitAmount'] ?? 1,
        numberOfUnits = data['numberOfUnits'] ?? 1,
        status = data['status'] ?? '',
        description = data['description'] ?? '',
        billed = data['billed'] ?? false,
        tax = data['tax'] ?? 0,
        extraCharges = data['extraCharges'] ?? 0,
        issueDate = (data['issueDate'] as Timestamp).toDate(),
        statusDate = (data['statusDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'partyId': partyId,
      'product': product,
      'perUnitAmount': perUnitAmount,
      'numberOfUnits': numberOfUnits,
      'status': status,
      'description': description,
      'billed': billed,
      'tax': tax,
      'extraCharges': extraCharges,
      'issueDate': issueDate,
      'statusDate': statusDate,
    };
  }
}
