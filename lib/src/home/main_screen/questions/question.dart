import 'dart:math';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:duolingo/src/home/main_screen/home.dart';
import 'package:duolingo/src/home/main_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:duolingo/src/home/main_screen/questions/models/question_class.dart';
import 'package:duolingo/src/home/main_screen/questions/models/result_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:just_audio/just_audio.dart';




class VideoScreen extends StatefulWidget {
  final List<Question> questionss;
  final int pointsto;
  final int level;
  final String link;
  final String text;
  VideoScreen({this.pointsto,this.level,this.questionss,this.link,this.text});
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  void _showConfirmation(){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context){
          return Container(
            padding: EdgeInsets.all(16),
            height: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Text('Are you sure you want to quit?',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 10,),
                Text('All progress wil be lost',style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey
                ),),
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
                      Navigator.of(context).pop();
                    },
                    child: Text('STAY',style: TextStyle(
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
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    _controller.pause();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home()),
                    );
                  },
                  child: Text(
                      'QUIT',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7e7e94), // Text color
                        // Underline the text
                      )
                  ),
                )
              ],
            ),
          );
        }
    );
  }
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '${widget.link}',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  onPressedContinueButton() {
    _controller.pause();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextScreen(
          text: widget.text,
          questionss: widget.questionss,
          pointsto: widget.pointsto,
          level: widget.level,
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_sharp,
            color: Colors.grey,
          ),
          onPressed: () {
            _showConfirmation();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ProgressIndicator(progress: 0,),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: YoutubePlayer(
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
              ),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7e4a3b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                ),
                onPressed: () {
                  onPressedContinueButton();
                },
                child: Text(
                  'Продолжить',
                  style: TextStyle(
                    fontFamily: 'Geo',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


class QuestionScreen extends StatefulWidget {
  final List<Question> questionss;
  final int pointsto;
  final int level;

  QuestionScreen({this.questionss,this.pointsto,this.level});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;
  bool isLastQuestion = false;
  int correctAnswersCount = 0;
  bool allQuestionsAnswered = false;
  int totalQuestionsCount;
  List<Question> currentQuestions;
  double progress = 0.0; // Добавьте переменную для отслеживания прогресса

  void initState() {
    super.initState();
    totalQuestionsCount = widget.questionss.length;
    currentQuestions = List.from(widget.questionss);
  }
  void updatePointsInFirebase(String currentUserUID,pointsToAdd) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child('users/$currentUserUID/points').once().then((DatabaseEvent snapshot) {

      int currentValue = snapshot.snapshot.value ?? 0; // Если значение не существует, устанавливаем 0

      int updatedValue = currentValue + pointsToAdd;
      databaseReference.child('users/$currentUserUID/points').set(updatedValue);
    });
  }
  void updatelevelInFirebase(String currentUserUID) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    int pointsToAdd = 50;

    databaseReference.child('users/$currentUserUID/level').once().then((DatabaseEvent snapshot) {

      int currentLvl = snapshot.snapshot.value ?? 1; // Если значение не существует, устанавливаем 0
      if (currentLvl == widget.level+1){
        databaseReference.child('users/$currentUserUID/level').set(widget.level+2);
        updatePointsInFirebase(currentUserUID, 50);

      }
      else{
        updatePointsInFirebase(currentUserUID, 10);
      }
    });
  }
  User currentUser = FirebaseAuth.instance.currentUser;


  void goToNextQuestion() {
    if (currentQuestionIndex < currentQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isLastQuestion = currentQuestionIndex == currentQuestions.length - 1;
        progress = (correctAnswersCount) / totalQuestionsCount; // Обновите прогресс
      });
    } else {
      setState(() {
        allQuestionsAnswered = true; // Set to true when all questions are answered
      });
    }
  }

  // Остальной код QuestionScreen...

  @override
  Widget build(BuildContext context) {
    final question = currentQuestions[currentQuestionIndex];

    if (allQuestionsAnswered && currentUser != null) {
      String currentUserUID = currentUser.uid;
      updatelevelInFirebase(currentUserUID);
      return ResultScreen(score: correctAnswersCount, len: totalQuestionsCount);
    }

    void _showConfirmation(){
      showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context){
            return Container(
              padding: EdgeInsets.all(16),
              height: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Text('Are you sure you want to quit?',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 10,),
                  Text('All progress wil be lost',style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey
                  ),),
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
                            Navigator.of(context).pop();
                      },
                      child: Text('STAY',style: TextStyle(
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
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => Home()),
                      );
                    },
                    child: Text(
                      'QUIT',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7e7e94), // Text color
                         // Underline the text
                      )
                    ),
                  )
                ],
              ),
            );
          }
      );
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_sharp,
            color: Colors.grey, // Set the color of the back arrow to red
          ),
          onPressed: () {
            _showConfirmation();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ProgressIndicator(progress: progress),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0), // Отступы по краям
            padding: EdgeInsets.all(16.0), // Внутренний отступ
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), // Закругленные углы
              border: Border.all(
                color: Colors.black, // Цвет границы
                width: 1.0, // Ширина границы
              ),
            ),
            child: Text(question.question,style: TextStyle(fontFamily: 'Geo',fontSize: 20),),
          ),
          if (question.questionType == QuestionType.multipleChoice)
            MultipleChoiceQuestion(
              questions: currentQuestions,
              question: question,
              onNextQuestion: () {
                goToNextQuestion();
              },
              onAnswerCorrect: () {
                if(currentQuestionIndex < totalQuestionsCount){
                  setState(() {
                    correctAnswersCount++;
                  });
                }
              },
            )
          else if (question.questionType == QuestionType.textInput)
            TextInputQuestion(
              questions: currentQuestions,
              question: question,
              onNextQuestion: () {
                goToNextQuestion();
              },
              onAnswerCorrect: () {
                // Увеличьте счетчик правильных ответов
                if(currentQuestionIndex < totalQuestionsCount){
                  setState(() {
                    correctAnswersCount++;
                  });
                }
              },
            ),
        ],
      ),
    );
  }
}

class MultipleChoiceQuestion extends StatefulWidget {
  final Question question;
  final Function() onNextQuestion;
  final Function() onAnswerCorrect;
  final List<Question> questions;
  final List<String> congratulatoryMessages = [
    'Good Job!',
    'Great!',
    'Well done!',
    'Fantastic!',
    'Awesome!'
  ];

  MultipleChoiceQuestion({this.question, this.onNextQuestion, this.onAnswerCorrect,this.questions});

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {

  int selectedOptionIndex;
  bool isAnswerCorrect = false;
  AudioPlayer audioPlayer = AudioPlayer();

  String _getRandomCongratulatoryMessage(List<String> messages) {
    final Random random = Random();
    return messages[random.nextInt(messages.length)];
  }

  void addMistakeToFirebase(Question question) {
    final User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
      final String userMistakesPath = 'users/${user.uid}/mistakes';

      // Проверяем, существует ли уже такой вопрос в списке ошибок пользователя
      databaseReference.child(userMistakesPath).once().then((DatabaseEvent snapshot) {
        List<dynamic> mistakes = snapshot.snapshot.value ?? [];

        // Проверяем, не существует ли уже такого вопроса
        bool questionExists = mistakes.any((mistake) {
          // Сравниваем вопросы по полям "question" и "questionType"
          return mistake['question'] == question.question;
        });

        if (!questionExists) {
          // Вопрос не существует в списке ошибок, добавляем
          List<dynamic> updatedMistakes = List.from(mistakes);
          updatedMistakes.add(question.toMap());

          if (updatedMistakes.length > 15) {
            updatedMistakes.removeAt(0);
          }

          databaseReference.child(userMistakesPath).set(updatedMistakes);
        }
      }).catchError((error) {
        print("Ошибка при добавлении ошибки в базу данных: $error");
      });
    } else {
      // Обработка случая, когда пользователь не аутентифицирован
    }
  }

  void playSound(bool isCorrect) async {
    // Change the prefix to your audio assets folder

    try {
      if (isCorrect) {
        await audioPlayer.setAsset('assets/Correct_answer.mp3');
        await audioPlayer.play();
        print("audio played");
      } else {
        await audioPlayer.setAsset('assets/Wrong_answer.mp3');
        await audioPlayer.play();
        print("audio");// Replace with your incorrect sound file
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _showResultDialog(bool isCorrect) {
    String congratulatoryMessage = _getRandomCongratulatoryMessage(widget.congratulatoryMessages);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,// Запрещаем закрытие при нажатии вне окна
      builder: (BuildContext context) {
        return !isCorrect?Container(
          height: 150,
          color: Colors.red[300].withOpacity(0.45),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Correct Solution:',
                style: TextStyle(fontSize: 20.0, fontFamily: 'Feather',color: Colors.red),
              ),
              SizedBox(height: 12.0),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child:Text(
                           '${widget.question.options[widget.question.correctAnswerIndex]}',
                        style: TextStyle(fontSize: 16.0,color: Colors.red, fontFamily: 'Geo'),
                        overflow: TextOverflow.ellipsis,
                      )
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),

                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      selectedOptionIndex = null;
                    });
                    widget.onNextQuestion(); // Перейти к следующему вопросу
                  },
                  child: Text('CONTINUE',style: TextStyle(fontFamily: 'Feather',fontSize: 15),),
                ),
              ),
            ],
          ),
        )
            :
        Container(
          height: 120,
          color: Colors.green[400].withOpacity(0.45),
          padding: EdgeInsets.only(left: 16,right: 16,top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                congratulatoryMessage ,
                style: TextStyle(fontSize: 20.0, fontFamily: 'Feather',color: Colors.green),
              ),

              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.green ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      selectedOptionIndex = null;
                    });
                    widget.onNextQuestion(); // Перейти к следующему вопросу
                  },
                  child: Text('CONTINUE',style: TextStyle(fontFamily: 'Feather',fontSize: 15),),
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: widget.question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;

              final isSelected = selectedOptionIndex == index;
              final color = isSelected ? Colors.blueAccent.withOpacity(0.65) : null;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOptionIndex = isSelected ? null : index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(13.0),
                    color: color,
                  ),
                  child: Row(
                    children: [
                      SizedBox(height: isSelected? 25: 20,),
                      Expanded(
                        child: Text(

                          option,
                          textAlign: TextAlign.center, // Выравниваем текст по центру
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17)
                ),
                margin: EdgeInsetsDirectional.only(start: 20,end: 20,bottom: 20),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7e4a3b),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                  ),
                  onPressed: selectedOptionIndex != null ? () {
                    checkAnswer();
                  }: null,
                  child: Text('CHECK',style: TextStyle(
                    fontFamily: 'Feather',
                    fontSize: 15
                  ),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void checkAnswer() {
    if (selectedOptionIndex != null) {
      bool isCorrect = selectedOptionIndex == widget.question.correctAnswerIndex;
      setState(() {
        isAnswerCorrect = isCorrect;
      });

      if (isCorrect) {
        widget.onAnswerCorrect(); // Increase the correct answers count
      } else {
        addMistakeToFirebase(widget.question);
        setState(() {
          widget.questions.add(widget.question);
        });
      }
      playSound(isCorrect);
      _showResultDialog(isCorrect);
    }
  }

}

class TextInputQuestion extends StatefulWidget {
  final List<Question> questions;
  final Question question;
  final Function() onNextQuestion;
  final Function() onAnswerCorrect;



  final List<String> congratulatoryMessages = [
    'Good Job!',
    'Great!',
    'Well done!',
    'Fantastic!',
    'Awesome!'
  ];


  TextInputQuestion({this.question, this.onNextQuestion, this.onAnswerCorrect,this.questions});

  @override
  _TextInputQuestionState createState() => _TextInputQuestionState();
}

class _TextInputQuestionState extends State<TextInputQuestion> {
  final TextEditingController answerController = TextEditingController();
  bool isAnswerCorrect;
  bool isButtonDisabled = true;
  AudioPlayer audioPlayer = AudioPlayer();

  String _getRandomCongratulatoryMessage(List<String> messages) {
    final Random random = Random();
    return messages[random.nextInt(messages.length)];
  }






  @override
  void initState() {
    super.initState();
    answerController.addListener(_checkTextField);

  }

  void _checkTextField() {
    setState(() {
      isButtonDisabled = answerController.text.isEmpty;
    });
  }
  void addMistakeToFirebase(Question question) {
    final User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
      final String userMistakesPath = 'users/${user.uid}/mistakes';

      // Проверяем, существует ли уже такой вопрос в списке ошибок пользователя
      databaseReference.child(userMistakesPath).once().then((DatabaseEvent snapshot) {
        List<dynamic> mistakes = snapshot.snapshot.value ?? [];

        // Проверяем, не существует ли уже такого вопроса
        bool questionExists = mistakes.any((mistake) {
          // Сравниваем вопросы по полям "question" и "questionType"
          return mistake['question'] == question.question;
        });

        if (!questionExists) {
          // Вопрос не существует в списке ошибок, добавляем его
          List<dynamic> updatedMistakes = List.from(mistakes);
          updatedMistakes.add(question.toMap());

          if (updatedMistakes.length > 15) {
            updatedMistakes.removeAt(0);
          }

          // Устанавливаем обновленный список ошибок обратно в Firebase
          databaseReference.child(userMistakesPath).set(updatedMistakes);
        }
      }).catchError((error) {
        print("Ошибка при добавлении ошибки в базу данных: $error");
      });
    } else {
      // Обработка случая, когда пользователь не аутентифицирован
    }
  }

  void playSound(bool isCorrect) async {
    // Change the prefix to your audio assets folder

    try {
      if (isCorrect) {
        await audioPlayer.setAsset('assets/Correct_answer.mp3');
        await audioPlayer.play();
        print("audio played");
      } else {
        await audioPlayer.setAsset('assets/Wrong_answer.mp3');
        await audioPlayer.play();
        print("audio");// Replace with your incorrect sound file
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }


  void _showResultDialog(bool isCorrect) async {

    String congratulatoryMessage = _getRandomCongratulatoryMessage(widget.congratulatoryMessages);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,// Запрещаем закрытие при нажатии вне окна
      builder: (BuildContext context) {
        return !isCorrect?Container(
          height: 150,
          color: Colors.red[300].withOpacity(0.45),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Correct Solution:',
                style: TextStyle(fontSize: 20.0, fontFamily: 'Geo',color: Colors.red),
              ),
              SizedBox(height: 12.0),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child:Text(
                        '${widget.question.correctInputAns}',
                        style: TextStyle(fontSize: 16.0,color: Colors.red, fontFamily: 'Feather'),
                        overflow: TextOverflow.ellipsis,
                      )
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),

                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    answerController.clear();
                    widget.onNextQuestion();// Перейти к следующему вопросу
                  },
                  child: Text('CONTINUE',style: TextStyle(fontFamily: 'Feather',fontSize: 15),),
                ),
              ),
            ],
          ),
        )
            :
        Container(
          height: 120,
          color: Colors.green[400].withOpacity(0.45),
          padding: EdgeInsets.only(left: 16,right: 16,top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                 congratulatoryMessage,
                style: TextStyle(fontSize: 20.0, fontFamily: 'Feather',color:  Colors.green),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    answerController.clear();
                    widget.onNextQuestion();// Перейти к следующему вопросу
                  },
                  child: Text('CONTINUE',style: TextStyle(fontFamily: 'Feather',fontSize: 15),),
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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(14),
              padding: EdgeInsets.only(left: 5),
              height: MediaQuery.of(context).size.width*0.80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 16
                ),
                controller: answerController,
                decoration: InputDecoration(
                    hintText:'Напишите сюда свой ответ' ,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17)
              ),
              margin: EdgeInsetsDirectional.only(start: 20,end: 20,bottom: 20),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7e4a3b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                ),
                child: Text('CHECK',style: TextStyle(
                    fontFamily: 'Feather',
                    fontSize: 15
                      ),),
                onPressed:  isButtonDisabled ? null : checkAnswer,
              ),
            ),
          ],
        ),
      ),
    );
  }




  Future<void> checkAnswer()  async{
    final userAnswer = answerController.text;
    bool isCorrect = userAnswer == widget.question.correctInputAns;
    setState(() {
      isAnswerCorrect = isCorrect;
    });

    if (isCorrect) {

      widget.onAnswerCorrect();
      // Increase the correct answers count
    } else {
      print(widget.question.toMap());
      addMistakeToFirebase(widget.question);
      setState(() {
        widget.questions.add(widget.question);
      });
    }
    playSound(isCorrect);
    _showResultDialog(isCorrect);

  }


}
class ProgressIndicator extends StatelessWidget {
  final double progress;

  ProgressIndicator({this.progress});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 10,
      value: progress,
      backgroundColor: Colors.grey,
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7e4a3b)),
    );
  }
}

class TextScreen extends StatefulWidget {
  final List<Question> questionss;
  final int pointsto;
  final int level;
  final String text;
  TextScreen({this.pointsto,this.level,this.questionss,this.text});
  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  void _showConfirmation(){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context){
          return Container(
            padding: EdgeInsets.all(16),
            height: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Text('Are you sure you want to quit?',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 10,),
                Text('All progress wil be lost',style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey
                ),),
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
                      Navigator.of(context).pop();
                    },
                    child: Text('STAY',style: TextStyle(
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
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home()),
                    );
                  },
                  child: Text(
                      'QUIT',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7e7e94), // Text color
                        // Underline the text
                      )
                  ),
                )
              ],
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_sharp,
            color: Colors.grey, // Установите цвет стрелки "назад" на красный
          ),
          onPressed: () {
            _showConfirmation();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ProgressIndicator(progress: 0,),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16.0), // Отступы по краям
                    padding: EdgeInsets.all(16.0), // Внутренний отступ
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0), // Закругленные углы
                      border: Border.all(
                        color: Colors.black, // Цвет границы
                        width: 1.0, // Ширина границы
                      ),
                    ),
                    child: Text(widget.text),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
              ),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7e4a3b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionScreen(
                        questionss: widget.questionss,
                        pointsto: widget.pointsto,
                        level: widget.level,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Продолжить',
                  style: TextStyle(
                    fontFamily: 'Geo',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

