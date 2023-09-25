import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AppBarHomeScreen extends StatefulWidget {
  @override
  State<AppBarHomeScreen> createState() => _AppBarHomeScreenState();
}

class _AppBarHomeScreenState extends State<AppBarHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }



  String language = '';
  int userPoints = 0;

  Future<void> _getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _databaseReference = FirebaseDatabase.instance.reference().child('users/${user.uid}');
        final dataSnapshot = await _databaseReference.once();
        final Map<dynamic, dynamic> data = dataSnapshot.snapshot.value;
        print(data);

        setState(() {
          userPoints = data['points'];
          language = data['language'];
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  String checkLanguage(String language){
    if(language=='C++')
      return 'assets/images/C+++.png';

    else if(language=='python')
      return 'assets/images/Python.png';

    else if(language=='javaScript')
      return 'assets/images/Javascript.png';

    else if(language=='CS')
      return 'assets/images/C_sharp.png';

    else
      return 'assets/images/white.png';

  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 16),
            icon: Image.asset(checkLanguage(language)),
            onPressed: () {},
          ),
          elevation: 3,
          actions: <Widget>[
            Row(
              children: <Widget> [

                Image.asset('assets/images/Small_Logo.png',height: 70,width: 150,),
                SizedBox(width: 33,),


                   Image.asset(
                    "assets/images/appBar/crown_stroke.png",
                    height: 29,
                  ),

                Text(
                  "$userPoints",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      fontSize: 17),
                ),
                const SizedBox(
                  width: 30,
                ),

              ],
            ),
          ],
    );
  }
}