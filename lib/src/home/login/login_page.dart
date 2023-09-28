import 'package:duolingo/src/pages/create_account.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  String buttonText = 'The free, fun, and \n effective way to learn  programming!'; // Initial button text
  String language="en";
  String FirstText ='GET STARTED';
  String SecondText ='ALREADY HAVE AN ACCOUNT';

  void changeButtonTexttoRu() {
    setState(() {
      FirstText='НАЧАТЬ';
      SecondText='УЖЕ ЕСТЬ АККАУНТ?';
      buttonText = 'Бесплатный, веселый и \n эффективный способ обучения программированию!';
      language='ru';// Change the button text here
    });
  }

  void changeButtonTexttoKz() {
    setState(() {
      FirstText='BASTAU';
      SecondText="SIZDE ESEPTIK JAZBA BAR?";
      buttonText = 'Baǵdarlamalaýdy úırenýdiń \n tegin, kóńildi jáne tıimdi ádisi!';
      language='kz';// Change the button text here
    });
  }
  void changeButtonTexttoEn() {
    setState(() {
      FirstText='GET STARTED';
      SecondText ='ALREADY HAVE AN ACCOUNT';
      buttonText = "The free, fun, and \n effective way to learn  programming!";
      language='en';// Change the button text here
    });
  }

  void _showResultDialog() {

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,// Запрещаем закрытие при нажатии вне окна
      builder: (BuildContext context) {
        return Container(height: 250,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (){
                    setState(() {
                      changeButtonTexttoEn();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('English',style: TextStyle(
                      fontFamily: 'Feather',
                      fontSize: 16
                  ),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF7e7e94),
                    onPrimary: Colors.white, // text color
                    elevation: 5, // shadow elevation// button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // button border radius
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (){
                    setState(() {
                      changeButtonTexttoRu();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Russian',style: TextStyle(
                      fontFamily: 'Feather',
                      fontSize: 16
                  ),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF7e7e94),
                    onPrimary: Colors.white, // text color
                    elevation: 5, // shadow elevation// button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // button border radius
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (){
                    setState(() {
                      changeButtonTexttoKz();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Kazakh',style: TextStyle(
                      fontFamily: 'Feather',
                      fontSize: 16
                  ),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF7e7e94),
                    onPrimary: Colors.white, // text color
                    elevation: 5, // shadow elevation// button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // button border radius
                    ),
                  ),
                ),
              ),
            ],
          ),

        );
      },
    );
  }






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
                    Image.asset('assets/images/LOGO_MAIN.png',height: 150,width: MediaQuery.of(context).size.width,),],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      _showResultDialog();
                    }, icon: Icon(Icons.language,color: Colors.grey,))
                  ]
                ),
                Image.asset('assets/images/Backend.gif',height: 280,width: 500,),
                SizedBox(height: 20,),

                Text(buttonText,
                style: TextStyle(
                  fontFamily: language=='ru'?"Geo":'Feather',
                  fontWeight: FontWeight.bold,
                  fontSize: language=='ru'?27:32,
                  color: Colors.black54
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed:
                        (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChooseLanguage()));
                        },
                    child: Text(FirstText,
                    style: TextStyle(
                      fontFamily: language=='ru'?"Geo":'Feather',
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
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed:
                        (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogINaccount()));
                        },
                    child: Text(SecondText,style:
                      TextStyle(
                        fontFamily: language=='ru'?"Geo":'Feather',
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




