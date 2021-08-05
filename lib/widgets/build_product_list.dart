import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class BuildProductList extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final List<dynamic> products;
  BuildProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return products.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: kBoxDecorationStyle,
                child: ListTile(
                  title: Text(
                    products[index].toString(),
                    style: kLabelStyle,
                    overflow: TextOverflow.fade,
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: kRegularColor,
                          title: Text(
                            'Alert Dialog',
                            style: kLabelStyle,
                          ),
                          content: Text(
                            'Do you want to delete this product ?',
                            style: kLabelStyle,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                products.remove(products[index]);
                                _firebaseServices
                                    .updateProductList(product: products)
                                    .whenComplete(
                                        () => Navigator.of(context).pop());
                              },
                              child: Text(
                                'Yes',
                                style: kLabelStyle,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style: kLabelStyle,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          )
        : Text(
            'No product yet',
            style: kLabelStyle,
            overflow: TextOverflow.fade,
          );
  }
}
