import 'package:cheque_app/models/parties_model.dart';
import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/screens/party_detail_screen.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cheque_app/utilities/extension.dart';

class BuildPartyList extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final MiscFunctions _miscFunctions = MiscFunctions();
  final String searchField;
  BuildPartyList({Key? key, required this.searchField}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return StreamProvider<List<PartiesModel>>.value(
      value: _userModel.role == 'Sales' || _userModel.role == ''
          ? _firebaseServices.searchPartiesSales(
              searchField: searchField, products: _userModel.products)
          : _firebaseServices.searchParties(searchField: searchField),
      initialData: [],
      builder: (context, snapshots) {
        List<PartiesModel> _parties = [];
        _parties.addAll(Provider.of<List<PartiesModel>>(context));
        if (_parties.isNotEmpty)
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: _parties.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: kBoxDecorationStyle,
                    child: ListTile(
                      title: Text(
                        '${_parties[index].name.capitalizeFirstofEach}',
                        style: kLabelStyle,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_parties[index].location.capitalizeFirstofEach}',
                            style: kLabelStyle,
                          ),
                          Text(
                            'Product: ${_parties[index].product}',
                            style: kLabelStyle,
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${_miscFunctions.formattedDate(_parties[index].registrationDate)}',
                        style: kLabelStyle,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PartyDetailScreen(
                              partiesModel: _parties[index],
                              userModel: _userModel,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        if (_userModel.role == 'Admin') {
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
                                  'Do you want to delete this party ?',
                                  style: kLabelStyle,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _firebaseServices.deleteFromParty(
                                        id: _parties[index].id,
                                      );
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
                },
              ),
            ],
          );
        if (searchField != '' && _parties.isEmpty) {
          return Text(
            'No such party',
            style: kLabelStyle,
            overflow: TextOverflow.ellipsis,
          );
        } else {
          return Text(
            'No parties yet',
            style: kLabelStyle,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}
