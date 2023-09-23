import 'package:duolingo/src/home/login/login_page.dart';
import 'package:duolingo/src/home/main_screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/home/main_screen/home.dart';

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
      home: AuthChecker(),
    );
  }
}


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the user is already logged in.
  Future<bool> isLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  // Sign in with email and password.
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      return user?.uid;
    } catch (e) {
      return null; // Handle authentication errors here.
    }
  }

  // Sign out the user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder<bool>(
      future: authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while checking login status.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? Home() : LoginPage();
        }
      },
    );
  }
}
