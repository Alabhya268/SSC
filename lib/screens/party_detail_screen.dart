import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_add_payment_dialog.dart';
import 'package:cheque_app/widgets/build_payment_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PartyDetail extends StatefulWidget {
  final PartiesModel party;
  final String role;
  const PartyDetail({Key? key, required this.party, required this.role})
      : super(key: key);

  @override
  _PartyDetailState createState() => _PartyDetailState();
}

class _PartyDetailState extends State<PartyDetail> {
  ValueNotifier<String> _chequeSearch = ValueNotifier<String>('');
  bool _isApproved = true;
  bool _isPending = true;
  bool _isBounced = true;
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
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${widget.party.name}',
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
                    '${widget.party.location}',
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
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
                    height: 60.0,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      onChanged: (value) {
                        _chequeSearch.value = value;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(Icons.person_outline),
                        hintText: 'Enter party name',
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      _isBounced == false &&
                                      _isPending == false) {
                                    _isApproved = true;
                                    _isBounced = true;
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
                                      _isBounced == false &&
                                      _isPending == false) {
                                    _isApproved = true;
                                    _isBounced = true;
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
                      Container(
                        child: Row(
                          children: [
                            Checkbox(
                                value: _isBounced,
                                checkColor: Colors.green,
                                activeColor: Colors.white,
                                onChanged: (value) {
                                  setState(() {
                                    _isBounced = value as bool;
                                  });
                                  if (_isApproved == false &&
                                      _isBounced == false &&
                                      _isPending == false) {
                                    _isApproved = true;
                                    _isBounced = true;
                                    _isPending = true;
                                  }
                                }),
                            Text(
                              'Bounced',
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
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ValueListenableBuilder(
                        builder: (BuildContext context, String value,
                            Widget? child) {
                          return BuildPaymentList(
                            party: widget.party,
                            role: widget.role,
                            isApproved: _isApproved,
                            isBounced: _isBounced,
                            isPending: _isPending,
                            chequeSearch: value,
                          );
                        },
                        valueListenable: _chequeSearch,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.role == 'Admin' || widget.role == 'Accountant')
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
                      return BuildAddPaymentDialog(
                        partiesModel: widget.party,
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
