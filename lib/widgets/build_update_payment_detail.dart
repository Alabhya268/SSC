import 'package:cheque_app/models/notification_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/extension.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';

class BuildUpdatePaymentDetail extends StatefulWidget {
  final PartiesModel partiesModel;
  final String role;
  final PaymentModel paymentModel;
  const BuildUpdatePaymentDetail({
    Key? key,
    required this.role,
    required this.paymentModel,
    required this.partiesModel,
  }) : super(key: key);

  @override
  _BuildUpdatePaymentDetailState createState() =>
      _BuildUpdatePaymentDetailState();
}

class _BuildUpdatePaymentDetailState extends State<BuildUpdatePaymentDetail> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MiscFunctions _miscFunctions = MiscFunctions();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _paymentNumberController = TextEditingController();
  var _statusDate;
  var _issueDate;
  late bool _isFreezed;
  late String _statusValue;

  @override
  void initState() {
    _statusDate = widget.paymentModel.statusDate;
    _issueDate = widget.paymentModel.issueDate;
    _isFreezed = widget.paymentModel.isFreezed;
    _statusValue = widget.paymentModel.status;
    _amountController.text = widget.paymentModel.amount.toString();
    _paymentNumberController.text = widget.paymentModel.paymentNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _statusOptions = [
      'Pending',
      'Approved',
      'Bounced',
    ];
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Update Cheque', style: kLabelStyle),
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
              noSpace: true,
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
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _issueDate = pickedDate;
                        });
                      }
                    },
                    icon: Icon(Icons.date_range_outlined,
                        color: kRegularIconColor),
                    label: Text('${_miscFunctions.formattedDate(_issueDate)}',
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
                      if (_statusValue == 'Pending')
                        Icon(
                          Icons.pending_outlined,
                          color: kRegularIconColor,
                        ),
                      if (_statusValue == 'Approved')
                        Icon(
                          Icons.check,
                          color: kRegularIconColor,
                        ),
                      if (_statusValue == 'Bounced')
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
                          color: kRegularIconColor,
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
                )
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
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(
                          () {
                            _statusDate = pickedDate;
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.date_range_outlined,
                        color: kRegularIconColor),
                    label: Text(
                      '${_miscFunctions.formattedDate(_statusDate)}',
                      style: kLabelStyle,
                    ),
                  ),
                ),
                if (widget.role == 'Admin') ...[
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Freeze Details',
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
                              value: _isFreezed,
                              checkColor: Colors.green,
                              activeColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  _isFreezed = value as bool;
                                });
                              },
                            ),
                            Text(
                              _isFreezed ? 'Freezed' : 'Not Freezed',
                              style: kLabelStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(
                  height: 10,
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
            await _firebaseServices
                .updatePaymentDetails(
                  chequeId: widget.paymentModel.id,
                  paymentNumber: _paymentNumberController.text,
                  amount: double.parse(_amountController.text),
                  issueDate: _issueDate,
                  status: _statusValue,
                  statusDate: _statusDate,
                  isFreezed: _isFreezed,
                )
                .whenComplete(() {
                  if (_statusValue != widget.paymentModel.status) {
                    NotificationModel _notificationModel = NotificationModel(
                        title: 'Payment status updated',
                        message:
                            'Payment status of ${widget.partiesModel.name.capitalizeFirstofEach} from ${widget.partiesModel.location.capitalizeFirstofEach} has been updated to $_statusValue',
                        product: '');
                    _firebaseServices.addToNotification(
                        notificationModel: _notificationModel);
                  }
                })
                .whenComplete(
                  () => Navigator.of(context).pop(),
                )
                .onError(
                  (error, stackTrace) => print(error),
                );
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
