import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildSelectProducts extends StatefulWidget {
  @override
  _BuildSelectProductsState createState() => _BuildSelectProductsState();
  List<dynamic> selectedProducts = [];
}

class _BuildSelectProductsState extends State<BuildSelectProducts> {
  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    List<dynamic> _products = Provider.of<List<dynamic>>(context);
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Select products', style: kLabelStyle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < _products.length; i++) ...[
              ListTile(
                title: Text(
                  _products[i],
                  style: kLabelStyle,
                ),
                trailing: Checkbox(
                  value: widget.selectedProducts.contains(_products[i]),
                  onChanged: (value) {
                    setState(
                      () {
                        if (value as bool) {
                          widget.selectedProducts.add(_products[i]);
                        } else {
                          widget.selectedProducts.remove(_products[i]);
                        }
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Ok',
            style: kLabelStyle,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
