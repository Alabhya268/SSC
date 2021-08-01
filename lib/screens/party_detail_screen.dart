import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/screens/orders_screen.dart';
import 'package:cheque_app/screens/payments_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/extension.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartyDetailScreen extends StatefulWidget {
  final PartiesModel partiesModel;
  final UserModel userModel;
  const PartyDetailScreen({
    Key? key,
    required this.partiesModel,
    required this.userModel,
  }) : super(key: key);

  @override
  _PartyDetailScreenState createState() => _PartyDetailScreenState();
}

class _PartyDetailScreenState extends State<PartyDetailScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MiscFunctions _miscFunctions = MiscFunctions();
  @override
  Widget build(BuildContext context) {
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
            value: _firebaseServices.getPartyPayments(
                partyId: widget.partiesModel.id),
            initialData: [],
            catchError: (context, snapshot) {
              return [];
            },
          ),
          StreamProvider<List<OrdersModel>>.value(
            value: _firebaseServices.getPartyOrders(
                partyId: widget.partiesModel.id),
            initialData: [],
            catchError: (context, snapshot) {
              return [];
            },
          ),
          StreamProvider<PartiesModel>.value(
            value: _firebaseServices.getPartyDetail(
              partyId: widget.partiesModel.id,
            ),
            initialData: PartiesModel(
              limit: widget.partiesModel.limit,
              location: widget.partiesModel.location,
              name: widget.partiesModel.name,
              product: widget.partiesModel.product,
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
          List<OrdersModel> _orderList =
              Provider.of<List<OrdersModel>>(context);
          List<PaymentModel> _paymentList =
              Provider.of<List<PaymentModel>>(context);
          double _totalPayment = 0;
          double _totalOutStanding = 0;
          _paymentList.forEach((element) {
            if (element.status == 'Approved')
              _totalPayment = _totalPayment + element.amount;
          });
          _orderList.forEach((element) {
            if (element.status == 'Approved')
              _totalOutStanding = _totalOutStanding + element.totalOrder;
          });
          double _credit =
              _partiesModel.limit - _totalOutStanding + _totalPayment;
          return Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: kBackgroundBoxStyle,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${_partiesModel.name.capitalizeFirstofEach}',
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
                          '${_partiesModel.location.capitalizeFirstofEach}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 15.0,
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
                                height: 30,
                              ),
                              Center(
                                child: Text(
                                  'Party Details',
                                  style: kTextStyleRegular,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Party id',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_partiesModel.id}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Name',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_partiesModel.name}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Location',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_partiesModel.location}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Created at',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_miscFunctions.formattedDate(_partiesModel.registrationDate)}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Product',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_partiesModel.product}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Limit',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_partiesModel.limit}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Outstanding',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '$_totalPayment',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Credit',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '$_credit',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: kButtonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                limit: _partiesModel.limit,
                                partyModel: _partiesModel,
                                userModel: _userModel,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Orders List',
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: kButtonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentsScreen(
                                party: _partiesModel,
                                role: _userModel.role,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Payments List',
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
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
