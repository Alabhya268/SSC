import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_add_order.dart';
import 'package:cheque_app/widgets/build_order_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheque_app/utilities/extension.dart';

class OrdersScreen extends StatefulWidget {
  final PartiesModel partyModel;
  final UserModel userModel;
  const OrdersScreen({
    Key? key,
    required this.partyModel,
    required this.userModel,
  }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();
  bool _isApproved = true;
  bool _isPending = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logos/launcher_icon.png',
              height: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'SSC',
              style: kTextStyleRegular,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Color(0xFF73AEF5),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: kBackgroundBoxStyle,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: StreamProvider<List<OrdersModel>>.value(
                value: _firebaseServices.getPartyOrders(
                    partyId: widget.partyModel.id),
                initialData: [],
                catchError: (context, snapshots) {
                  return [];
                },
                builder: (context, snapshots) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Orders',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${widget.partyModel.name.capitalizeFirstofEach}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Checkbox(
                                    value: _isApproved,
                                    checkColor: Colors.green,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        _isApproved = value as bool;
                                      });
                                      if (_isApproved == false &&
                                          _isPending == false) {
                                        _isApproved = true;
                                        _isPending = true;
                                      }
                                    }),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Checkbox(
                                    value: _isPending,
                                    checkColor: Colors.green,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        _isPending = value as bool;
                                      });
                                      if (_isApproved == false &&
                                          _isPending == false) {
                                        _isApproved = true;
                                        _isPending = true;
                                      }
                                    }),
                                Text(
                                  'Pending',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: BuildOrderList(
                          isApproved: _isApproved,
                          isPending: _isPending,
                          party: widget.partyModel,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (widget.userModel.role == 'Admin' ||
              widget.userModel.role == 'Accountant' ||
              widget.userModel.canAddParty)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return BuildAddOrder(
                        partiesModel: widget.partyModel,
                        userModel: widget.userModel,
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
