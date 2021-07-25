import 'package:cheque_app/models/orders_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildAddOrder extends StatefulWidget {
  final PartiesModel partiesModel;
  final UserModel userModel;
  const BuildAddOrder({
    Key? key,
    required this.partiesModel,
    required this.userModel,
  }) : super(key: key);

  @override
  _BuildAddOrderState createState() => _BuildAddOrderState();
}

class _BuildAddOrderState extends State<BuildAddOrder> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _statusValue = 'Pending';
  List<String> _statusOptions = [
    'Pending',
    'Approved',
  ];
  TextEditingController _numberOfUnits = TextEditingController();
  TextEditingController _perUnitAmount = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool _billed = false;
  TextEditingController _tax = TextEditingController();
  TextEditingController _extraCharges = TextEditingController();
  DateTime _selectedStatusDate = DateTime.now();
  DateTime _selectedIssueDate = DateTime.now();

  late OrdersModel _orderModel;
  @override
  Widget build(BuildContext context) {
    _tax.text = '0';
    _extraCharges.text = '0';
    _numberOfUnits.text = '1';
    _perUnitAmount.text = '1';
    _description.text = '';

    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Add Cheque', style: kLabelStyle),
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
                if (widget.userModel.canEditOrderStatus ||
                    widget.userModel.role == 'Accountant' ||
                    widget.userModel.role == 'Admin')
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
                            _selectedStatusDate = pickedDate;
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.date_range_outlined,
                        color: kRegularIconColor),
                    label: Text(DateFormat.yMMMMd().format(_selectedStatusDate),
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
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Add',
            style: kLabelStyle,
          ),
          onPressed: () {
            _orderModel = OrdersModel(
              partyId: widget.partiesModel.id,
              uid: _firebaseServices.getCurrentUserId(),
              product: widget.partiesModel.product,
              perUnitAmount: double.parse(_perUnitAmount.text),
              numberOfUnits: double.parse(_numberOfUnits.text),
              status: _statusValue,
              description: _description.text,
              billed: _billed,
              tax: double.parse(_tax.text),
              extraCharges: double.parse(_extraCharges.text),
              issueDate: _selectedIssueDate,
              statusDate: _selectedStatusDate,
            );
            _firebaseServices.addToOrder(orderModel: _orderModel).whenComplete(
              () async {
                if (_statusValue == _statusOptions[1]) {
                  return _firebaseServices
                      .updateUserOrders(
                          uid: widget.userModel.uid,
                          orders:
                              await _firebaseServices.getCurrentUserOrders() +
                                  1)
                      .whenComplete(() => Navigator.of(context).pop());
                }
                Navigator.of(context).pop();
              },
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
