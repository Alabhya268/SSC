import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/screens/payments_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

class PartyDetailScreen extends StatefulWidget {
  final PartiesModel partiesModel;
  final UserModel userModel;
  const PartyDetailScreen(
      {Key? key, required this.partiesModel, required this.userModel})
      : super(key: key);

  @override
  _PartyDetailScreenState createState() => _PartyDetailScreenState();
}

class _PartyDetailScreenState extends State<PartyDetailScreen> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MiscFunctions _miscFunctions = MiscFunctions();
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
          MultiProvider(
              providers: [
                StreamProvider<List<PaymentModel>>.value(
                  value: _firebaseServices.getPartyPayments(
                      partyId: widget.partiesModel.id),
                  initialData: [],
                ),
                StreamProvider<PartiesModel>.value(
                  value: _firebaseServices.getPartyDetail(
                      partyId: widget.partiesModel.id),
                  initialData: PartiesModel(
                    limit: widget.partiesModel.limit,
                    location: widget.partiesModel.location,
                    name: widget.partiesModel.name,
                    product: widget.partiesModel.product,
                  ),
                ),
              ],
              builder: (context, widget) {
                PartiesModel _party = Provider.of<PartiesModel>(context);
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: kBackgroundBoxStyle,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${_party.name.capitalizeFirstofEach}',
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
                          '${_party.location.capitalizeFirstofEach}',
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
                                  'Party Id',
                                  style: kTextStyleRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${_party.id}',
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
                                  '${_party.name.capitalizeFirstofEach}',
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
                                  '${_party.location.capitalizeFirstofEach}',
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
                                  '${_miscFunctions.formattedDate(_party.registrationDate)}',
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
                                  '${_party.product}',
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
                                  '${_party.limit}',
                                  style: kTextStyleRegularSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: kButtonStyle,
                            onPressed: () {},
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
                      ],
                    ),
                  ),
                );
              }),
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
                        party: widget.partiesModel,
                        role: widget.userModel.role),
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
    );
  }
}
