import 'package:cheque_app/models/notification_model.dart';
import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/extension.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';

import 'build_error_dialog.dart';

class BuildUpdateOrderDetail extends StatefulWidget {
  final PartiesModel partiesModel;
  final double credit;
  final OrdersModel ordersModel;
  final UserModel userModel;
  const BuildUpdateOrderDetail({
    Key? key,
    required this.ordersModel,
    required this.userModel,
    required this.credit,
    required this.partiesModel,
  }) : super(key: key);

  @override
  _BuildUpdateOrderDetailState createState() => _BuildUpdateOrderDetailState();
}

class _BuildUpdateOrderDetailState extends State<BuildUpdateOrderDetail> {
  FirebaseServices _firebaseServices = FirebaseServices();
  MiscFunctions _miscFunctions = MiscFunctions();
  TextEditingController _numberOfUnits = TextEditingController();
  TextEditingController _perUnitAmount = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _tax = TextEditingController();
  late bool _billed;
  TextEditingController _extraCharges = TextEditingController();
  late DateTime _issueDate;
  late String _statusValue;
  late DateTime _statusDate;
  late NotificationModel _notificationModel;
  double _totalOrderAmount = 0;

  @override
  void initState() {
    _numberOfUnits.text = widget.ordersModel.numberOfUnits.toString();
    _perUnitAmount.text = widget.ordersModel.perUnitAmount.toString();
    _billed = widget.ordersModel.billed;
    _extraCharges.text = widget.ordersModel.extraCharges.toString();
    _issueDate = widget.ordersModel.issueDate;
    _statusValue = widget.ordersModel.status;
    _statusDate = widget.ordersModel.statusDate;
    _description.text = widget.ordersModel.description;
    _tax.text = widget.ordersModel.tax.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _statusOptions = [
      'Pending',
      'Approved',
    ];
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Update Order', style: kLabelStyle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BuildInput(
              fieldName: 'Number of units',
              hintText: 'Enter number of units',
              controller: _numberOfUnits,
              textInputType: TextInputType.number,
              passwordfield: false,
              noSpace: true,
              icon: Icon(
                Icons.format_list_numbered,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BuildInput(
              fieldName: 'Unit amount',
              hintText: 'Enter unit amount',
              controller: _perUnitAmount,
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
                  'Billed',
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
                        value: _billed,
                        checkColor: Colors.green,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _billed = value as bool;
                          });
                        },
                      ),
                      Text(
                        _billed ? 'Billed' : 'Not Billed',
                        style: kLabelStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            if (_billed) ...[
              BuildInput(
                fieldName: 'Tax',
                hintText: 'Enter Tax',
                controller: _tax,
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
            ],
            BuildInput(
              fieldName: 'Extra charges',
              hintText: 'Enter extra charges',
              controller: _extraCharges,
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
            BuildInput(
              fieldName: 'Description',
              hintText: 'Enter description',
              controller: _description,
              textInputType: TextInputType.multiline,
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
                    label: Text(_miscFunctions.formattedDate(_issueDate),
                        style: kLabelStyle),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            if (widget.userModel.canEditOrderStatus ||
                widget.userModel.role == 'Accountant' ||
                widget.userModel.role == 'Admin') ...[
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
                              firstDate: DateTime(
                                  DateTime.now().year - DateTime(5).year),
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
                          label: Text(_miscFunctions.formattedDate(_statusDate),
                              style: kLabelStyle),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
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
            if (_tax.text.isEmpty) {
              _tax.text = '0';
            }
            if (_extraCharges.text.isEmpty) {
              _extraCharges.text = '0';
            }
            if (_numberOfUnits.text.isEmpty || _perUnitAmount.text.isEmpty) {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return BuildErrorDialog(
                    title: 'Alert',
                    errorMessage: 'Number of units and Unit amount is required',
                  );
                },
              );
            } else {
              double _principle = double.parse(_perUnitAmount.text) *
                  double.parse(_numberOfUnits.text);
              double _taxOnPrinciple = double.parse(_perUnitAmount.text) *
                  double.parse(_numberOfUnits.text) *
                  double.parse(_tax.text) *
                  0.01;
              _totalOrderAmount = _principle +
                  _taxOnPrinciple +
                  double.parse(_extraCharges.text);
              if (_totalOrderAmount > widget.credit &&
                  _statusValue == _statusOptions[1]) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return BuildErrorDialog(
                      title: 'Alert',
                      errorMessage:
                          'Total amount of order: $_totalOrderAmount \n Remaining credit: ${widget.credit}',
                    );
                  },
                );
              } else {
                await _firebaseServices
                    .updateOrderDetails(
                  orderId: widget.ordersModel.id,
                  numberOfUnits: double.parse(_numberOfUnits.text),
                  perUnitAmount: double.parse(_perUnitAmount.text),
                  billed: _billed,
                  tax: double.parse(_tax.text),
                  extraCharges: double.parse(_extraCharges.text),
                  description: _description.text,
                  issueDate: _issueDate,
                  status: _statusValue,
                  statusDate: _statusDate,
                )
                    .whenComplete(() {
                  if (_statusValue != widget.ordersModel.status) {
                    _notificationModel = NotificationModel(
                        title: 'Order status updated',
                        message:
                            'Order status of ${widget.partiesModel.name.capitalizeFirstofEach} from ${widget.partiesModel.location.capitalizeFirstofEach} has been updated to $_statusValue',
                        product: widget.partiesModel.product);
                    _firebaseServices.addToNotifications(
                        notificationModel: _notificationModel);
                  }
                }).whenComplete(() async {
                  if (widget.ordersModel.status == _statusOptions.first) {
                    if (_statusValue == _statusOptions[1]) {
                      await _firebaseServices.updateUserOrders(
                          uid: widget.userModel.uid,
                          orders: await _firebaseServices
                                  .getUserOrders(widget.ordersModel.uid) +
                              1);
                    }
                  } else {
                    if (_statusValue == _statusOptions.first) {
                      await _firebaseServices.updateUserOrders(
                          uid: widget.userModel.uid,
                          orders: await _firebaseServices
                                  .getUserOrders(widget.ordersModel.uid) -
                              1);
                    }
                  }
                  Navigator.of(context).pop();
                }).onError(
                  (error, stackTrace) => print(error),
                );
              }
            }
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
