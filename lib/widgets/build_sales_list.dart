import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BuildSalesList extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  BuildSalesList({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  List<OrdersModel> _orders = [];
  Map _sales = Map();
  List<Map> _salesList = [];

  @override
  Widget build(BuildContext context) {
    FirebaseServices _firebaseServices = FirebaseServices();
    _orders = Provider.of<List<OrdersModel>>(context)
        .where((element) =>
            element.issueDate.isBefore(endDate) &&
            element.issueDate.isAfter(startDate) &&
            element.status == 'Approved')
        .toList();

    _orders.forEach((element) {
      if (!_sales.containsKey(element.product)) {
        _sales[element.product] = 1;
      } else {
        _sales[element.product] += 1;
      }
    });

    _sales.forEach((key, value) {
      _salesList.add({key: value});
    });
    return _sales.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _salesList.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: kBoxDecorationStyle,
                child: ListTile(
                  title: Text(
                    'Amount: ${_salesList[index].keys.first}',
                    style: kLabelStyle,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Text(
                    'Status: ${_salesList[index].values.first}',
                    style: kLabelStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          )
        : Text(
            'No Sales',
            style: kLabelStyle,
            overflow: TextOverflow.ellipsis,
          );
  }
}
