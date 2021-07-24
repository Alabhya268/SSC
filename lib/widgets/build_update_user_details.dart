import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class BuildUpdateUserDetail extends StatefulWidget {
  final String role;
  final String uid;
  final bool approved;
  const BuildUpdateUserDetail(
      {Key? key, required this.role, required this.uid, required this.approved})
      : super(key: key);

  @override
  _BuildUpdateUserDetailState createState() => _BuildUpdateUserDetailState();
}

class _BuildUpdateUserDetailState extends State<BuildUpdateUserDetail> {
  late String _role;
  late bool _approved;

  void initState() {
    _role = widget.role;
    _approved = widget.approved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _firebaseServices = FirebaseServices();
    List<String> _roleOptions = [
      'Accountant',
      'Sales',
    ];
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Add Party', style: kLabelStyle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest Status Date',
                  style: kLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  child: Row(
                    children: [
                      if (_role == _roleOptions.first)
                        Icon(
                          Icons.person,
                          color: kRegularIconColor,
                        ),
                      if (_role == _roleOptions[1])
                        Icon(
                          Icons.person_outline,
                          color: kRegularIconColor,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        dropdownColor: kRegularColor,
                        value: _role,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: kLabelStyle,
                        underline: Container(
                          decoration: kBoxDecorationStyle,
                          alignment: Alignment.center,
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _role = newValue!;
                          });
                        },
                        items: _roleOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: kLabelStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: kLabelStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _approved,
                            checkColor: Colors.green,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                _approved = value as bool;
                              });
                            },
                          ),
                          Text(
                            _approved ? 'Approved' : 'Not Approved',
                            style: kLabelStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              'Update',
              style: kLabelStyle,
            ),
            onPressed: () async {
              await _firebaseServices.updateUserDetails(
                uid: widget.uid,
                approved: _approved,
                role: _role,
              );
              Navigator.of(context).pop();
            }),
        TextButton(
          child: Text(
            'Cancel',
            style: kLabelStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
