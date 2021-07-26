import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildAddPayment extends StatefulWidget {
  final PartiesModel partiesModel;
  const BuildAddPayment({Key? key, required this.partiesModel})
      : super(key: key);

  @override
  _BuildAddPaymentState createState() => _BuildAddPaymentState();
}

class _BuildAddPaymentState extends State<BuildAddPayment> {
  FirebaseServices _firebaseServices = FirebaseServices();

  DateTime _selectedLatestStatusDate = DateTime.now();
  DateTime _selectedIssueDate = DateTime.now();
  String _statusValue = 'Pending';
  List<String> _statusOptions = [
    'Pending',
    'Approved',
    'Bounced',
  ];
  TextEditingController _paymentNumberController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  late PaymentModel _paymentModel;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Add Payment', style: kLabelStyle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BuildInput(
              fieldName: 'Cheque number/ Utr number/ Cash',
              hintText: 'Enter here',
              controller: _paymentNumberController,
              textInputType: TextInputType.streetAddress,
              passwordfield: false,
              icon: Icon(
                Icons.format_list_numbered,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BuildInput(
              fieldName: 'Amount',
              hintText: 'Enter amount',
              controller: _amountController,
              textInputType: TextInputType.number,
              passwordfield: false,
              icon: Icon(
                Icons.money,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Issue Date',
                  style: kLabelStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  child: TextButton.icon(
                    onPressed: () async {
                      var pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime(DateTime.now().year - DateTime(5).year),
                        lastDate:
                            DateTime(DateTime.now().year + DateTime(5).year),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedIssueDate = pickedDate;
                        });
                      }
                    },
                    icon: Icon(Icons.date_range_outlined,
                        color: kRegularIconColor),
                    label: Text(DateFormat.yMMMMd().format(_selectedIssueDate),
                        style: kLabelStyle),
                  ),
                ),
              ],
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
                      if (_statusValue == _statusOptions.first)
                        Icon(
                          Icons.pending_outlined,
                          color: kRegularIconColor,
                        ),
                      if (_statusValue == _statusOptions[1])
                        Icon(
                          Icons.check,
                          color: kRegularIconColor,
                        ),
                      if (_statusValue == _statusOptions[2])
                        Icon(
                          Icons.error_outline,
                          color: kRegularIconColor,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        dropdownColor: kRegularColor,
                        value: _statusValue,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: kLabelStyle,
                        underline: Container(
                          decoration: kBoxDecorationStyle,
                          alignment: Alignment.center,
                          height: 0,
                        ),
                        onChanged: (String? newValue) async {
                          setState(() {
                            _statusValue = newValue!;
                          });
                        },
                        items: _statusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: kLabelStyle,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
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
                  child: TextButton.icon(
                    onPressed: () async {
                      var pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime(DateTime.now().year - DateTime(5).year),
                        lastDate:
                            DateTime(DateTime.now().year + DateTime(5).year),
                      );
                      if (pickedDate != null) {
                        setState(
                          () {
                            _selectedLatestStatusDate = pickedDate;
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.date_range_outlined,
                        color: kRegularIconColor),
                    label: Text(
                        DateFormat.yMMMMd().format(_selectedLatestStatusDate),
                        style: kLabelStyle),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text(
              'Add',
              style: kLabelStyle,
            ),
            onPressed: () {
              if (_paymentNumberController.text.isEmpty ||
                  _amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All fields are necessary'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                _paymentModel = PaymentModel(
                  partyId: widget.partiesModel.id,
                  name: widget.partiesModel.name,
                  paymentNumber: _paymentNumberController.text,
                  amount: double.parse(_amountController.text),
                  issueDate: _selectedIssueDate,
                  status: _statusValue,
                  statusDate: _selectedLatestStatusDate,
                );
                _firebaseServices.addToPayment(paymentModel: _paymentModel);
                Navigator.of(context).pop();
              }
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
