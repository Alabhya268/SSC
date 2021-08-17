import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:cheque_app/widgets/build_update_order_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheque_app/utilities/extension.dart';

class OrderDetailScreen extends StatefulWidget {
  final UserModel userModel;
  final PartiesModel partyModel;
  final OrdersModel orderModel;
  const OrderDetailScreen({
    Key? key,
    required this.orderModel,
    required this.partyModel,
    required this.userModel,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MiscFunctions _miscFunctions = MiscFunctions();

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
              'SSC CHQ',
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
                horizontal: 20.0,
              ),
              child: SingleChildScrollView(
                child: MultiProvider(
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
                    StreamProvider<OrdersModel>.value(
                      value: _firebaseServices.getOrderDetail(
                          orderId: widget.orderModel.id),
                      initialData: OrdersModel(
                        id: widget.orderModel.id,
                        name: widget.orderModel.name,
                        uid: widget.orderModel.uid,
                        partyId: widget.orderModel.partyId,
                        product: widget.orderModel.product,
                        perUnitAmount: widget.orderModel.perUnitAmount,
                        numberOfUnits: widget.orderModel.numberOfUnits,
                        status: widget.orderModel.status,
                        description: widget.orderModel.description,
                        billed: widget.orderModel.billed,
                        tax: widget.orderModel.tax,
                        extraCharges: widget.orderModel.extraCharges,
                        issueDate: widget.orderModel.issueDate,
                        statusDate: widget.orderModel.statusDate,
                      ),
                    ),
                  ],
                  builder: (context, widget) {
                    OrdersModel _orderModel = Provider.of<OrdersModel>(context);
                    PartiesModel _partiesModel =
                        Provider.of<PartiesModel>(context);
                    List<OrdersModel> _orderList =
                        Provider.of<List<OrdersModel>>(context);
                    List<PaymentModel> _paymentList =
                        Provider.of<List<PaymentModel>>(context);
                    double _totalPayment = 0;
                    double _totalOrder = 0;
                    _paymentList.forEach((element) {
                      _totalPayment = _totalPayment + element.amount;
                    });
                    _orderList.forEach((element) {
                      _totalOrder = _totalOrder + element.totalOrder;
                    });
                    double _totalOutStanding = _totalOrder - _totalPayment;
                    double _credit = _partiesModel.limit - _totalOutStanding;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${_orderModel.name.capitalizeFirstofEach}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${_partiesModel.location.capitalizeFirstofEach}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: kBoxDecorationStyle,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  'Order Details',
                                  style: kTextStyleRegular,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Order id',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_orderModel.id}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Number of units',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_orderModel.numberOfUnits}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Per unit amount',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_orderModel.perUnitAmount}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Billing status',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  _orderModel.billed ? 'Billed' : 'Not Billed',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (_orderModel.billed)
                                ListTile(
                                  title: Text(
                                    'Tax',
                                    style: kTextStyleRegular,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '${_orderModel.tax}',
                                    style: kTextStyleRegularSubtitle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ListTile(
                                title: Text(
                                  'Extra charges',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_orderModel.extraCharges}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Description',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  _orderModel.description.isEmpty
                                      ? 'No description'
                                      : '${_orderModel.description}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Issue date',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_miscFunctions.formattedDate(_orderModel.issueDate)}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Status',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_orderModel.status}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Status date',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_miscFunctions.formattedDate(_orderModel.statusDate)}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 25.0),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15.0),
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return BuildUpdateOrderDetail(
                                    credit: _credit,
                                    ordersModel: _orderModel,
                                    userModel: _userModel,
                                    partiesModel: _partiesModel,
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
