import 'package:be_marvellous/app/landing_page.dart';
import 'package:be_marvellous/app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: "Be Marvellous",
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: LandingPage(),
      ),
    );
  }
}
