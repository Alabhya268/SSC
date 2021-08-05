import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_Input.dart';
import 'package:flutter/material.dart';

class BuildAddProduct extends StatelessWidget {
  final List<dynamic> products;
  final TextEditingController _productController = TextEditingController();
  final FirebaseServices _firebaseServices = FirebaseServices();
  BuildAddProduct({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kRegularColor,
      title: Text('Add product', style: kLabelStyle),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            BuildInput(
              fieldName: 'Enter new party limit',
              hintText: 'Enter here',
              controller: _productController,
              textInputType: TextInputType.streetAddress,
              passwordfield: false,
              icon: Icon(
                Icons.format_list_numbered,
              ),
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
          onPressed: () async {
            products.add(_productController.text);
            _firebaseServices
                .updateProductList(product: products)
                .whenComplete(() => Navigator.of(context).pop());
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
