import 'package:duolingo/src/home/main_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:duolingo/src/home/main_screen/questions/question.dart';


class ResultScreen extends StatelessWidget {
  const ResultScreen({
    key,
    this.score,
    this.len
  });

  final int score;
  final int len;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF002137),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          }, icon: Icon(Icons.close_sharp,color: Colors.white,))
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white30,
          ),

          height: MediaQuery.of(context).size.width * 0.95,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: Image.asset('assets/images/Trophy.gif')),
              SizedBox(height: 10),
              Text(
                'Congrats!!',
                style: TextStyle(fontFamily: 'Feather', fontSize: 23),
              ),
              SizedBox(height: 20),
              Text(
                '${(score / len * 100).round()}% Score',
                style: const TextStyle(fontSize: 37,fontFamily: 'Feather',color: Colors.green),
              ),
              SizedBox(height: 24,),
              Text(
                'Level completed successfully.'
                  ,style: TextStyle(
                  fontSize: 18,fontFamily: 'Feather',
              ),
              ),
            ],
          ),
        )
      )


      /*Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 1000),
          const Text(
            'Your Score: ',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  value: score / len,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    score.toString(),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(score / len * 100).round()}%',
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
            ],
          ),
        ],
      ),*/
    );
  }
}