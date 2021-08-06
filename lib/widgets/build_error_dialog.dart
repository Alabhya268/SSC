import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class BuildErrorDialog extends StatelessWidget {
  final String title;
  final String errorMessage;
  const BuildErrorDialog(
      {Key? key, this.title = '', required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text(
        title == '' ? 'Error' : title,
        style: kLabelStyle,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              errorMessage,
              style: kLabelStyle,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Ok',
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
