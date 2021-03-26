import 'package:be_marvellous/app/common_widgets/show_alert_dialog.dart';
import 'package:be_marvellous/app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async{
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didReqSignOut = await showAlertDialog(
        context,
        title: 'Logout',
        content: 'Are you sure?',
        cancelActionText: 'Cancel',
        defaultActionText: 'Logout',
    );
    if(didReqSignOut == true){
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
              onPressed: () => _confirmSignOut(context),
              child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
