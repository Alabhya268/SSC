import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';

class BuildPartyLimit extends StatefulWidget {
  final String partyId;
  final double limit;
  final double totalOutStanding;
  const BuildPartyLimit({
    Key? key,
    required this.partyId,
    required this.limit,
    required this.totalOutStanding,
  }) : super(key: key);

  @override
  _BuildPartyLimitState createState() => _BuildPartyLimitState();
}

class _BuildPartyLimitState extends State<BuildPartyLimit> {
  FirebaseServices _firebaseServices = FirebaseServices();
  TextEditingController _limitController = TextEditingController();
  bool _showError = false;

  @override
  void initState() {
    _limitController.text = widget.limit.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Update Limit', style: kLabelStyle),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            BuildInput(
              fieldName: 'Enter new party limit',
              hintText: 'Enter here',
              controller: _limitController,
              textInputType: TextInputType.streetAddress,
              passwordfield: false,
              icon: Icon(
                Icons.format_list_numbered,
              ),
            ),
            if (_showError) ...[
              SizedBox(
                height: 10,
              ),
              Text(
                'Limit can\'t be lesser than outstanding',
                style: kErrorStyle,
              ),
            ],
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
            double.parse(_limitController.text) >= widget.totalOutStanding
                ? await _firebaseServices
                    .updatePartyLimit(
                      partyId: widget.partyId,
                      limit: double.parse(_limitController.text),
                    )
                    .whenComplete(
                      () => Navigator.of(context).pop(),
                    )
                    .onError(
                      (error, stackTrace) => print(error),
                    )
                : setState(() {
                    _showError = true;
                  });
          },
        ),
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
