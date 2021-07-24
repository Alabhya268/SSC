import 'package:cheque_app/models/payment_model.dart';
import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/screens/payment_detail_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BuildPaymentList extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final MiscFunctions _miscFunctions = MiscFunctions();

  final PartiesModel party;
  final String role;
  final bool isApproved;
  final bool isPending;
  final bool isBounced;
  String chequeSearch;

  BuildPaymentList({
    Key? key,
    this.role = '',
    required this.isApproved,
    required this.isPending,
    required this.isBounced,
    required this.party,
    this.chequeSearch = '',
  }) : super(key: key);

  List<PaymentModel> _cheque = [];

  @override
  Widget build(BuildContext context) {
    String _approved = isApproved ? 'Approved' : '';
    String _pending = isPending ? 'Pending' : '';
    String _bounced = isBounced ? 'Bounced' : '';

    _cheque = Provider.of<List<PaymentModel>>(context);
    _cheque = _cheque
        .where((cheque) =>
            cheque.paymentNumber.startsWith(chequeSearch) &&
            (cheque.status == _approved ||
                cheque.status == _pending ||
                cheque.status == _bounced))
        .toList();

    return _cheque.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _cheque.length,
            itemBuilder: (context, index) {
              if (_cheque[index]
                  .paymentNumber
                  .startsWith(chequeSearch)) if (_cheque[index].status ==
                      _approved ||
                  _cheque[index].status == _pending ||
                  _cheque[index].status == _bounced) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: kBoxDecorationStyle,
                  child: ListTile(
                    title: Text(
                      'Cheque no: ${_cheque[index].paymentNumber}',
                      style: kLabelStyle,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount: ${_cheque[index].amount}',
                          style: kLabelStyle,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          'Status: ${_cheque[index].status}',
                          style: kLabelStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Text(
                      'Issue date \n ${_miscFunctions.formattedDate(_cheque[index].issueDate)}',
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
                            paymentModel: _cheque[index],
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
                                'Do you want to delete this cheque details ?',
                                style: kLabelStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _firebaseServices
                                        .deleteFromCheques(_cheque[index].id);
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
            'No cheques',
            style: kLabelStyle,
            overflow: TextOverflow.ellipsis,
          );
  }
}
