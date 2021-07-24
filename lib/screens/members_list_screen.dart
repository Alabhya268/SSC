import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_members_list.dart';
import 'package:flutter/material.dart';

class MembersListScreen extends StatefulWidget {
  MembersListScreen({Key? key}) : super(key: key);

  @override
  _MembersListScreenState createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  bool _isApproved = true;
  bool _isNotApproved = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  'Members',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
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
                                    _isNotApproved == false) {
                                  _isApproved = true;
                                  _isNotApproved = true;
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
                              value: _isNotApproved,
                              checkColor: Colors.green,
                              activeColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  _isNotApproved = value as bool;
                                });
                                if (_isApproved == false &&
                                    _isNotApproved == false) {
                                  _isApproved = true;
                                  _isNotApproved = true;
                                }
                              }),
                          Text(
                            'Not approved',
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        BuildMembersList(
                          approved: _isApproved,
                          notApproved: _isNotApproved,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
