import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersModel {
  late String id;
  String name;
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
  late double totalOrder;
  DateTime issueDate = DateTime.now();
  DateTime statusDate = DateTime.now();

  OrdersModel({
    this.id = '',
    required this.name,
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
        name = data['name'] ?? '',
        partyId = data['partyId'] ?? '',
        product = data['product'] ?? '',
        perUnitAmount = data['perUnitAmount'].toDouble() ?? 1,
        numberOfUnits = data['numberOfUnits'].toDouble() ?? 1,
        status = data['status'] ?? '',
        description = data['description'] ?? '',
        billed = data['billed'] ?? false,
        tax = data['tax'] ?? 0,
        extraCharges = data['extraCharges'].toDouble() ?? 0,
        totalOrder = data['extraCharges'].toDouble() +
                (data['perUnitAmount'].toDouble() *
                    data['numberOfUnits'].toDouble()) +
                (data['perUnitAmount'].toDouble() *
                    data['numberOfUnits'].toDouble() *
                    data['tax'].toDouble() *
                    0.01) ??
            0,
        issueDate = (data['issueDate'] as Timestamp).toDate(),
        statusDate = (data['statusDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
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
