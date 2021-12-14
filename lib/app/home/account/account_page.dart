import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

class AccountPage extends StatelessWidget{
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        actions: <Widget>[

          FlatButton(
            child: const Text('Logout' , style: TextStyle(fontSize: 18.0, color: Colors.white),),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
  Future<void> _signOut(BuildContext context) async{
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    }catch(e){
      print('sign out err: ${e.toString()}');
    }
  }
  Future<void> _confirmSignOut(BuildContext context) async{
    final didRequestSignout = await showAlertDialog(
        context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        cancelActionText: 'cancel',
        defaultActionText: 'logout'
    );
    if(didRequestSignout == true) {
      _signOut(context);
    }
  }
  
}