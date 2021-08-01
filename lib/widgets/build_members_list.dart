import 'package:cheque_app/models/user_model.dart';
import 'package:cheque_app/services/firebase_service.dart';
import 'package:cheque_app/utilities/constants.dart';
import 'package:cheque_app/utilities/extension.dart';
import 'package:cheque_app/utilities/misc_functions.dart';
import 'package:cheque_app/widgets/build_update_member_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildMembersList extends StatefulWidget {
  final bool approved;
  final bool notApproved;
  BuildMembersList({required this.approved, required this.notApproved});
  @override
  _BuildMembersListState createState() => _BuildMembersListState();
}

class _BuildMembersListState extends State<BuildMembersList> {
  FirebaseServices _firebaseServices = FirebaseServices();

  MiscFunctions _miscFunctions = MiscFunctions();

  List<UserModel> _user = [];

  @override
  Widget build(BuildContext context) {
    bool _approved = widget.approved ? true : false;
    bool _notApproved = widget.notApproved ? false : true;

    return StreamProvider<List<UserModel>>.value(
      value: _firebaseServices.getUsers(),
      initialData: [],
      builder: (context, snapshots) {
        _user = Provider.of<List<UserModel>>(context);
        _user = _user
            .where((element) => element.role != 'Admin')
            .where((element) =>
                element.approved == _approved ||
                element.approved == _notApproved)
            .toList();
        if (_user.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _user.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: kBoxDecorationStyle,
                child: ListTile(
                  title: Text(
                    'Name: ${_user[index].name.capitalizeFirstofEach}',
                    style: kLabelStyle,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role: ${_user[index].role}',
                        style: kLabelStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Email: ${_user[index].email}',
                        style: kLabelStyle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        _user[index].approved
                            ? 'Status: Approved'
                            : 'Status: Not Approved',
                        style: kLabelStyle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        'Total orders: ${_user[index].orders.toString()}',
                        style: kLabelStyle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  trailing: Container(
                    height: double.infinity,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return BuildUpdateMemberDetail(
                              canAddParty: _user[index].canAddParty,
                              products: _user[index].products,
                              role: _user[index].role,
                              uid: _user[index].uid,
                              approved: _user[index].approved,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Text(
          'No Members yet',
          style: kLabelStyle,
        );
      },
    );
  }
}
