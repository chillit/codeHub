import 'package:duolingo/src/home/login/login_page.dart';
import 'package:duolingo/src/pages/create_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/home/login/welcome_screen.dart';
import 'src/home/main_screen/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Code-Hub",
      theme: ThemeData(primaryColor: Colors.white),
      home: Home(),
    );
  }
}
