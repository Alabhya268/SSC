import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/widgets/build_add_party.dart';
import 'package:cheque_app/widgets/build_party_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({Key? key}) : super(key: key);

  @override
  _PartiesScreenState createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  late String _search;
  TextEditingController _searchParty = TextEditingController();
  FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    _search = _searchParty.text;
    _searchFocus.unfocus();
    _isSearching = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    List<dynamic> _products = Provider.of<List<dynamic>>(context);

    return GestureDetector(
      onTap: () {
        _searchFocus.unfocus();
      },
      child: Stack(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: _searchFocus,
                            controller: _searchParty,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                            ),
                            onFieldSubmitted: (value) {
                              setState(() {
                                _search = value;
                              });
                            },
                            onChanged: (value) {
                              if (value == '') {
                                setState(() {
                                  _search = '';
                                  _isSearching = false;
                                });
                              } else {
                                setState(() {
                                  _isSearching = true;
                                });
                              }
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
                        if (_isSearching)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _search = '';
                                _searchParty.text = '';
                                _isSearching = false;
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: kRegularIconColor,
                            ),
                          )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Expanded(
                      child: BuildPartyList(
                    searchField: _search,
                  )),
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
      ),
    );
  }
}
