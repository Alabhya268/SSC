import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/extension.dart';
import 'package:cheque_app/widgets/build_add_order.dart';
import 'package:cheque_app/widgets/build_order_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  final double limit;
  final PartiesModel partyModel;
  final UserModel userModel;
  const OrdersScreen({
    Key? key,
    required this.partyModel,
    required this.userModel,
    required this.limit,
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
    PartiesModel _partiesModel = widget.partyModel;
    UserModel _userModel = widget.userModel;
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
      body: MultiProvider(
        providers: [
          StreamProvider<List<PaymentModel>>.value(
            value: _firebaseServices.getApprovedPartyPayments(
                partyId: _partiesModel.id),
            initialData: [],
            catchError: (context, snapshot) {
              return [];
            },
          ),
          StreamProvider<List<OrdersModel>>.value(
            value: _firebaseServices.getApprovedPartyOrders(
                partyId: _partiesModel.id),
            initialData: [],
          ),
          StreamProvider<PartiesModel>.value(
            value: _firebaseServices.getPartyDetail(
              partyId: _partiesModel.id,
            ),
            initialData: PartiesModel(
              limit: _partiesModel.limit,
              location: _partiesModel.location,
              name: _partiesModel.name,
              product: _partiesModel.product,
            ),
            catchError: (context, snapshot) {
              return PartiesModel(
                name: '',
                location: '',
                limit: 0,
                product: '',
              );
            },
          ),
        ],
        builder: (context, widget) {
          PartiesModel _partiesModel = Provider.of<PartiesModel>(context);
          List<OrdersModel> _approvedOrderList =
              Provider.of<List<OrdersModel>>(context);
          List<PaymentModel> _approvedPaymentList =
              Provider.of<List<PaymentModel>>(context);
          double _totalPayment = 0;
          double _totalOrder = 0;
          _approvedPaymentList.forEach((element) {
            _totalPayment = _totalPayment + element.amount;
          });
          _approvedOrderList.forEach((element) {
            _totalOrder = _totalOrder + element.totalOrder;
          });
          double _totalOutStanding = _totalOrder - _totalPayment;
          double _credit = _partiesModel.limit - _totalOutStanding;
          return Stack(
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
                  child: Column(
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
                        '${_partiesModel.name.capitalizeFirstofEach}',
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
                      Text(
                        'Credit: $_credit',
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
                          party: _partiesModel,
                          userModel: _userModel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                          credit: _credit,
                          partiesModel: _partiesModel,
                          userModel: _userModel,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
