import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  late String id;
  late String partyId;
  late String name;
  late String paymentNumber;
  late double amount;
  late DateTime issueDate;
  late String status;
  late DateTime statusDate;
  bool isFreezed = false;

  PaymentModel({
    required this.partyId,
    required this.name,
    required this.paymentNumber,
    required this.amount,
    required this.issueDate,
    required this.status,
    required this.statusDate,
  });

  PaymentModel.fromData(Map<String, dynamic> data)
      : partyId = data['partyId'] ?? '',
        name = data['name'] ?? '',
        paymentNumber = data['paymentNumber'] ?? '',
        amount = data['amount'] ?? 0,
        issueDate = (data['issueDate'] as Timestamp).toDate(),
        status = data['status'] ?? '',
        statusDate = (data['statusDate'] as Timestamp).toDate(),
        isFreezed = data['isFreezed'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'name': name,
      'paymentNumber': paymentNumber,
      'amount': amount,
      'issueDate': issueDate,
      'status': status,
      'statusDate': statusDate,
      'isFreezed': isFreezed,
    };
  }
}
