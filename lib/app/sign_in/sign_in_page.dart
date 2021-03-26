import 'package:be_marvellous/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:be_marvellous/app/services/auth.dart';
import 'package:be_marvellous/app/sign_in/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  const SignInPage({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception){
    showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: exception
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async{
    try{
      await bloc.signInAnonymously();
    } on Exception catch (e){
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try{
      await bloc.signInWithGoogle();
    } on Exception catch(e){
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Be Marvellous"),
        elevation: 2.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(context, snapshot.data);
        }
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildHeader(isLoading),
          SizedBox(height: 32),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.black87),
            ),
            child: Text("Sign in with Google"),
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            child: Text("Sign in Anonymously"),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading){
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "SIGN IN",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
