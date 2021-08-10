import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildSalesList extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final DateTime startDate;
  final DateTime endDate;

  BuildSalesList({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List<OrdersModel> _orders;
    Map _sales = Map();
    late List<Map> _salesList;
    return StreamProvider<List<OrdersModel>>.value(
      value: _firebaseServices.getOrdersInTimeRange(
          startDate: startDate, endDate: endDate),
      initialData: [],
      catchError: (context, snapshot) {
        return [];
      },
      builder: (context, widget) {
        _orders = Provider.of<List<OrdersModel>>(context);
        _orders.forEach((element) {
          if (!_sales.containsKey(element.product)) {
            _sales[element.product] = element.numberOfUnits;
          } else {
            _sales[element.product] =
                _sales[element.product] + element.numberOfUnits;
          }
        });
        _salesList = [];
        _sales.forEach((key, value) {
          _salesList.add({key: value});
          _sales = Map();
        });
        return _salesList.isNotEmpty
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
                        'Product: ${_salesList[index].keys.first}',
                        style: kLabelStyle,
                        overflow: TextOverflow.fade,
                      ),
                      subtitle: Text(
                        'Units ordered: ${_salesList[index].values.first}',
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
      },
    );
  }
}
