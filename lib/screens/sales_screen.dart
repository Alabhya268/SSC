import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:cheque_app/widgets/build_sales_list.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  MiscFunctions _miscFunctions = MiscFunctions();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _endDate = DateTime.now();

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
                  'Sales',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select Date Range',
                      style: kLabelStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      decoration: kBoxDecorationStyle,
                      child: Center(
                        child: TextButton.icon(
                          onPressed: () async {
                            var _pickedDate = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(
                                    DateTime.now().year - DateTime(5).year),
                                lastDate: DateTime.now());
                            if (_pickedDate != null) {
                              setState(() {
                                _startDate = _pickedDate.start;
                                _endDate = _pickedDate.end;
                              });
                            }
                          },
                          icon: Icon(Icons.date_range_outlined,
                              color: kRegularIconColor),
                          label: Text(
                              '${_miscFunctions.formattedDate(_startDate)} - ${_miscFunctions.formattedDate(_endDate)}',
                              style: kLabelStyle),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: BuildSalesList(
                    startDate: _startDate,
                    endDate: _endDate,
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
