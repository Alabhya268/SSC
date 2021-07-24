import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildInput extends StatelessWidget {
  BuildInput({
    Key? key,
    required this.fieldName,
    required this.hintText,
    required this.controller,
    required this.textInputType,
    required this.passwordfield,
    required this.icon,
  }) : super(key: key);

  final String fieldName;
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool passwordfield;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (fieldName != '')
          Text(
            '$fieldName',
            style: kLabelStyle,
          ),
        if (fieldName != '') SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: passwordfield,
            controller: controller,
            keyboardType: textInputType,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: icon,
              hintText: '$hintText',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
