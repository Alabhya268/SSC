import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BuildOrderList extends StatelessWidget {
  final MiscFunctions _miscFunctions = MiscFunctions();

  final PartiesModel party;
  final String role;
  final bool isApproved;
  final bool isPending;

  BuildOrderList({
    Key? key,
    this.role = '',
    required this.isApproved,
    required this.isPending,
    required this.party,
  }) : super(key: key);

  List<OrdersModel> _orders = [];

  @override
  Widget build(BuildContext context) {
    String _approved = isApproved ? 'Approved' : '';
    String _pending = isPending ? 'Pending' : '';

    _orders = Provider.of<List<OrdersModel>>(context);
    return _orders.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              if (_orders[index].status == _approved ||
                  _orders[index].status == _pending) {
                double _principleAmount =
                    _orders[index].perUnitAmount * _orders[index].numberOfUnits;
                double _totalAmount = _orders[index].extraCharges +
                    _principleAmount +
                    (_principleAmount * _orders[index].tax);
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: kBoxDecorationStyle,
                  child: ListTile(
                    title: Text(
                      'Amount: $_totalAmount',
                      style: kLabelStyle,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Text(
                      'Status: ${_orders[index].status}',
                      style: kLabelStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      'Issue date \n ${_miscFunctions.formattedDate(_orders[index].issueDate)}',
                      style: kLabelStyle,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {},
                    onLongPress: () {
                      if (role == 'Admin') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: kRegularColor,
                              title: Text(
                                'Alert Dialog',
                                style: kLabelStyle,
                              ),
                              content: Text(
                                'Do you want to delete this cheque details ?',
                                style: kLabelStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Yes',
                                    style: kLabelStyle,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: kLabelStyle,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              }
              return Container();
            },
          )
        : Text(
            'No Orders',
            style: kLabelStyle,
            overflow: TextOverflow.ellipsis,
          );
  }
}
