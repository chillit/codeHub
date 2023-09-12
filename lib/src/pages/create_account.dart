import 'package:duolingo/src/home/login/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({Key key}) : super(key: key);

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Container(
                        padding: EdgeInsetsDirectional.only(start: 30),
                        child: Image.asset('assets/images/Small_Logo.png',height: 70,width: 150,)),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              Text('I wanna learn...',
              style: TextStyle(
                fontFamily: 'Feather',
                fontSize: 32,
                color: Colors.black54,
              ),),
              SizedBox(height: 60,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareImageTextWidget(imageUrl: 'assets/images/Python.png',text: 'Python',),
                  SizedBox(width: 20,),
                  SquareImageTextWidget(imageUrl: 'assets/images/C+++.png',text: 'C++',)
                ],),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareImageTextWidget(imageUrl: 'assets/images/Javascript.png',text: 'JavaScript',),
                  SizedBox(width: 20,),
                  SquareImageTextWidget(imageUrl: 'assets/images/C_sharp.png',text: 'C#',)
                ],)
            ],
          ),
        ),
      ),
    );
  }
}

class SquareImageTextWidget extends StatelessWidget {
  const SquareImageTextWidget({Key key, this.imageUrl, this.text, this.onTap})
      : super(key: key);

  final String imageUrl;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    double containerSize = screenWidth * 0.45;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CreateUser()));
      },
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: Color.fromRGBO(191, 153, 130, 0.3),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Color.fromRGBO(126, 74, 59, 1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageUrl,
              width: containerSize * 0.4,
              height: containerSize * 0.4,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 10), // Space between image and text
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Feather',
                fontSize: containerSize * 0.1, // Adjust this factor as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateUser extends StatefulWidget {
  const CreateUser({Key key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {




  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController usernamecontroller=TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    usernamecontroller.dispose();

    super.dispose();
  }

  bool isEmailEmpty = true;
  bool isPasswordEmpty = true;

  void initState() {
    super.initState();

    // Listen for changes in the email and password fields
    emailcontroller.addListener(() {
      setState(() {
        isEmailEmpty = emailcontroller.text.isEmpty;
      });
    });
    passwordcontroller.addListener(() {
      setState(() {
        isPasswordEmpty = passwordcontroller.text.isEmpty;
      });
    });
  }

  bool _obscurePassword = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 8, right: 16),
              child: IconButton(
                icon: Icon(Icons.close,color: Colors.grey,size: 28,),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create your account',style: TextStyle(fontFamily: 'Feather',fontSize: 25),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/10),
                        child: Text('Username',style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Feather',
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10),
                    child: SizedBox(
                      height: 50,
                      width: 400,
                      child: Center(
                        child: TextFormField(
                          validator: (email)=>
                          email !=null
                              ? 'Write different username!!'
                              : null,
                          controller: usernamecontroller,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Feather',
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Feather',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Padding(
                        padding:   EdgeInsets.only(left: MediaQuery.of(context).size.width/10),
                        child: Text('Email',style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Feather',
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10),
                    child: SizedBox(
                      height: 50,
                      width: 400,
                      child: Center(
                        child: TextFormField(
                          validator: (email)=>
                          email !=null
                              ? 'Write correct email adress!!'
                              : null,
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Feather',
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Feather',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/10,),
                        child: Text('Password',style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Feather',
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10),
                    child: SizedBox(
                      height: 50,
                      width: 400,
                      child: Center(
                        child: TextFormField(
                          controller: passwordcontroller,
                          obscureText: _obscurePassword,
                          validator: (value)=>
                          value !=null && value.length<6
                              ? 'Write correct password!!'
                              : null,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Feather',
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: _togglePasswordVisibility,
                              ),
                              suffixIconColor: Colors.black
                          ),
                          style: TextStyle(
                            fontFamily: 'Feather',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10,right: MediaQuery.of(context).size.width/10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5,color: Colors.black54,),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      width: 400,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isEmailEmpty || isPasswordEmpty ? null:
                            (){
                        },
                        child: Text('CREATE ACCOUNT',style: TextStyle(
                          fontFamily: 'Feather',
                          fontSize: 18
                        ),),
                        style: ElevatedButton.styleFrom(
                          primary:isEmailEmpty || isPasswordEmpty ? Colors.grey[600] : Color.fromRGBO	(126,126,148,1),
                          // background color
                          onPrimary: isEmailEmpty || isPasswordEmpty ? Colors.black:Colors.white, // text color
                          elevation: 5, // shadow elevation// button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // button border radius
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.black26,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey[700],
                                fontFamily: 'Feather',
                                fontSize: 17,
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
          SizedBox(height: 30,),
          RichText(
            text: TextSpan(
              style: TextStyle(fontFamily: 'Feather'),
              children: <TextSpan>[
                TextSpan(text: 'Already have an account?  '),
                TextSpan(
                    text: 'LOG IN',
                    style: TextStyle(color: Color.fromRGBO	(160,82,45,1),fontFamily: 'Feather'),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogINaccount()));
                      }),
              ],
            ),
          ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
class LogINaccount extends StatefulWidget {
  const LogINaccount({Key key}) : super(key: key);

  @override
  State<LogINaccount> createState() => _LogINaccountState();
}

class _LogINaccountState extends State<LogINaccount> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();


  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  bool isEmailEmpty = true;
  bool isPasswordEmpty = true;

  void initState() {
    super.initState();

    // Listen for changes in the email and password fields
    emailcontroller.addListener(() {
      setState(() {
        isEmailEmpty = emailcontroller.text.isEmpty;
      });
    });
    passwordcontroller.addListener(() {
      setState(() {
        isPasswordEmpty = passwordcontroller.text.isEmpty;
      });
    });
  }

  bool _obscurePassword = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 8, right: 16),
              child: IconButton(
                icon: Icon(Icons.close,color: Colors.grey,size: 28,),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Log in',style: TextStyle(fontFamily: 'Feather',fontSize: 25),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Padding(
                        padding:  EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/10,),
                        child: Text('Email',style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Feather',
                        ),),
                      ),
                    ],
                  ),
                  Padding(

                    padding:  EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/10,end:MediaQuery.of(context).size.width/10),
                    child: SizedBox(
                      height: 50,
                      width: 400,
                      child: Center(
                        child: TextFormField(
                          validator: (email)=>
                          email !=null
                              ? 'Write correct email adress!!'
                              : null,
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Feather',
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Feather',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:  EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/10,),
                        child: Text('Password',style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Feather',
                        ),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/10,end:MediaQuery.of(context).size.width/10),
                    child: SizedBox(
                      height: 50,
                      width: 400,
                      child: Center(
                        child: TextFormField(
                          controller: passwordcontroller,
                          obscureText: _obscurePassword,
                          validator: (value)=>
                          value !=null && value.length<6
                              ? 'Write correct password!!'
                              : null,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Feather',
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: _togglePasswordVisibility,
                              ),
                              suffixIconColor: Colors.black
                          ),
                          style: TextStyle(
                            fontFamily: 'Feather',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding:  EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/10,end:MediaQuery.of(context).size.width/10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5,color: Colors.black54,),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      width: 400,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isEmailEmpty || isPasswordEmpty ? null:
                            (){

                        },
                        child: Text('LOG IN',style: TextStyle(
                            fontFamily: 'Feather',
                            fontSize: 18
                        ),),
                        style: ElevatedButton.styleFrom(
                          primary:isEmailEmpty || isPasswordEmpty ? Colors.grey[600] : Color.fromRGBO	(126,126,148,1),
                          // background color
                          onPrimary: isEmailEmpty || isPasswordEmpty ? Colors.black:Colors.white, // text color
                          elevation: 5, // shadow elevation// button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // button border radius
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.black26,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey[700],
                              fontFamily: 'Feather',
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'Feather'),
                      children: <TextSpan>[
                        TextSpan(text: 'Don\'t have an account?  '),
                        TextSpan(
                            text: 'SIGN UP',
                            style: TextStyle(color: Color.fromRGBO	(160,82,45,1),fontFamily: 'Feather'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChooseLanguage()));
                              }),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}




