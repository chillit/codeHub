import 'package:duolingo/src/pages/create_account.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/LOGO_MAIN.png',height: 150,width: MediaQuery.of(context).size.width,)],
                ),
                Image.asset('assets/images/Backend.gif',height: 280,width: 500,),
                SizedBox(height: 20,),

                Text('The free, fun, and \n effective way to learn  programming!',
                style: TextStyle(
                  fontFamily: 'Feather',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black54
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed:
                        (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChooseLanguage()));
                        },
                    child: Text('GET STARTED',
                    style: TextStyle(
                      fontFamily: 'Feather',
                      fontSize: 13,
                      color: Color.fromRGBO(221,196,173, 1),
                    ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(126,74,59, 1),
                      elevation: 5, // shadow elevation// button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // button border radius
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed:
                        (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogINaccount()));
                        },
                    child: Text('ALREADY HAVE AN ACCOUNT?',style:
                      TextStyle(
                        fontFamily: 'Feather',
                        fontSize: 13,
                        color: Color.fromRGBO(221,196,173, 1),
                      ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(126,74,59, 1),
                      elevation: 5, // shadow elevation// button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // button border radius
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          )
        ),
    );
  }
}


