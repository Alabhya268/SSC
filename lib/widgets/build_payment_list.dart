import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/screens/payment_detail_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildPaymentList extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final MiscFunctions _miscFunctions = MiscFunctions();

  final PartiesModel party;
  final String role;
  final bool isApproved;
  final bool isPending;
  final bool isBounced;
  final String paymentSearch;

  BuildPaymentList({
    Key? key,
    this.role = '',
    required this.isApproved,
    required this.isPending,
    required this.isBounced,
    required this.party,
    this.paymentSearch = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _approved = isApproved ? 'Approved' : '';
    String _pending = isPending ? 'Pending' : '';
    String _bounced = isBounced ? 'Bounced' : '';
    List<PaymentModel> _payment = [];

    _payment = Provider.of<List<PaymentModel>>(context);
    _payment = _payment
        .where((payment) =>
            payment.paymentNumber.startsWith(paymentSearch) &&
            (payment.status == _approved ||
                payment.status == _pending ||
                payment.status == _bounced))
        .toList();

    return _payment.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _payment.length,
            itemBuilder: (context, index) {
              if (_payment[index]
                  .paymentNumber
                  .startsWith(paymentSearch)) if (_payment[index].status ==
                      _approved ||
                  _payment[index].status == _pending ||
                  _payment[index].status == _bounced) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: kBoxDecorationStyle,
                  child: ListTile(
                    title: Text(
                      'payment : ${_payment[index].paymentNumber}',
                      style: kLabelStyle,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount: ${_payment[index].amount}',
                          style: kLabelStyle,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          'Status: ${_payment[index].status}',
                          style: kLabelStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Text(
                      'Issue date \n ${_miscFunctions.formattedDate(_payment[index].issueDate)}',
                      style: kLabelStyle,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentDetailScreen(
                            role: role,
                            paymentModel: _payment[index],
                            party: party,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      if (role == 'Admin') {
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
                                'Do you want to delete this payment details ?',
                                style: kLabelStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _firebaseServices.deleteFromPayment(
                                        id: _payment[index].id);
                                    Navigator.of(context).pop();
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
                      }
                    },
                  ),
                );
              }
              return Container();
            },
          )
        : Text(
            'No payments',
            style: kLabelStyle,
            overflow: TextOverflow.ellipsis,
          );
  }
}
