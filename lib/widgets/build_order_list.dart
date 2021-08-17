import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/screens/order_detail_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildOrderList extends StatelessWidget {
  final MiscFunctions _miscFunctions = MiscFunctions();

  final PartiesModel partyModel;
  final UserModel userModel;
  final bool isApproved;
  final bool isPending;

  BuildOrderList({
    Key? key,
    required this.isApproved,
    required this.isPending,
    required this.partyModel,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _firebaseServices = FirebaseServices();
    String _approved = isApproved ? 'Approved' : '';
    String _pending = isPending ? 'Pending' : '';
    List<OrdersModel> _orders = [];

    _orders = Provider.of<List<OrdersModel>>(context);
    return _orders.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              if (_orders[index].status == _approved ||
                  _orders[index].status == _pending) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: kBoxDecorationStyle,
                  child: ListTile(
                    title: Text(
                      'Amount: ${_orders[index].totalOrder}',
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                              orderModel: _orders[index],
                              partyModel: partyModel,
                              userModel: userModel),
                        ),
                      );
                    },
                    onLongPress: userModel.role == 'Admin'
                        ? () {
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
                                      onPressed: () {
                                        _firebaseServices.deleteFromOrder(
                                            id: _orders[index].id);
                                        Navigator.of(context).pop();
                                      },
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
                        : null,
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
