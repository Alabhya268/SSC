import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_add_party.dart';
import 'package:cheque_app/widgets/build_party_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PartiesListScreen extends StatefulWidget {
  const PartiesListScreen({Key? key}) : super(key: key);

  @override
  _PartiesListScreenState createState() => _PartiesListScreenState();
}

class _PartiesListScreenState extends State<PartiesListScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    List<dynamic> _products = Provider.of<List<dynamic>>(context);
    ValueNotifier<String> _searchParty = ValueNotifier<String>('');

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
                  'Parties',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  height: 60.0,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                    onChanged: (value) {
                      _searchParty.value = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Enter party name',
                      hintStyle: kHintTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ValueListenableBuilder(
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return BuildPartyList(
                          searchField: value,
                        );
                      },
                      valueListenable: _searchParty,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_userModel.canAddParty)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return BuildAddParty(
                      userModel: _userModel,
                      productList: _products,
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
