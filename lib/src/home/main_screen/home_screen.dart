import 'package:duolingo/src/components/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:duolingo/src/home/main_screen/questions/question.dart';
import 'package:duolingo/src/home/main_screen/questions/models/questions.dart';
import 'package:duolingo/src/home/main_screen/questions/models/question_class.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> pythonQuestions = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String currentUserUID;
  int userLevel;
  String userLanguage;


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      currentUserUID = user.uid;

      final levelRef = _database.reference().child('users/$currentUserUID/level');
      final languageRef = _database.reference().child('users/$currentUserUID/language');

      DatabaseEvent levelSnapshot = await levelRef.once();
      DatabaseEvent languageSnapshot = await languageRef.once();
      userLevel = levelSnapshot.snapshot.value;
      userLanguage = languageSnapshot.snapshot.value?.toString() ?? '';
      fetchPythonQuestions(userLevel,userLanguage);
    }
  }

  Future<void> fetchPythonQuestions(userLevel,userLanguage) async {
    final questions = await getPythonQuestions(userLevel,userLanguage);
    setState(() {
      pythonQuestions = questions;
    });
  }
  Future<List<Question>> getPythonQuestions(userLevel,userLanguage) async {
    final databaseReference = FirebaseDatabase.instance.reference();
    final DatabaseEvent dataSnapshot = await databaseReference.child('allq/$userLanguage/0').once();

    final questionsData = dataSnapshot.snapshot.value as List<dynamic>;
    final List<Question> pythonQuestions = [];

    for (final questionData in questionsData) {
      final question = Question(
        question: questionData['question'],
        correctAnswerIndex: questionData['correctAnswerIndex'],
        options: (questionData['options'] as List<dynamic>)?.map((option) => option.toString())?.toList(),
        questionType: QuestionType.values.firstWhere(
              (type) => type.toString() == 'QuestionType.${questionData['questionType']}',
          orElse: () => QuestionType.multipleChoice,
        ),
        correctInputAns: questionData['correctInputAns'],
      );

      pythonQuestions.add(question);
    }
    print(pythonQuestions);

    return pythonQuestions;
  }
  Text _textCirle(String text) =>
      Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 38),
          Column(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionScreen(questionss: pythonQuestions ), // Замените YourNewPage() на вашу новую страницу
                    ),
                  );
                },

                child: const CircleAvatarIndicator(Color(0xFF55acf3),
                    "assets/images/home_screen/lesson_egg.png"),
              ),
              const SizedBox(height: 10),
              _textCirle("Introdução"),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      userLevel>=1?await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(questionss: questions ), // Замените YourNewPage() на вашу новую страницу
                        ),
                      ):null;
                    },
                    child: Column(
                      children: <Widget>[
                        const CircleAvatarIndicator(Color(0xFF55acf3),
                            "assets/images/home_screen/lesson_dialog.png"),
                        const SizedBox(height: 10),
                        _textCirle("Suka"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 33),
                  InkWell(
                    onTap: () async {
                      userLevel>=2?await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(questionss: questions ), // Замените YourNewPage() на вашу новую страницу
                        ),
                      ):null;
                    },
                    child: Column(
                      children: <Widget>[
                        const CircleAvatarIndicator(Color(0xFF55acf3),
                            "assets/images/home_screen/lesson_airplane.png"),
                        const SizedBox(height: 10),
                        _textCirle("Zaebalo"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      userLevel>=3?await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(questionss: questions ), // Замените YourNewPage() на вашу новую страницу
                        ),
                      ):null;
                    },
                    child: Column(
                      children: <Widget>[
                        const CircleAvatarIndicator(Color(0xFF55acf3),
                            "assets/images/home_screen/lesson_hamburger.png"),
                        const SizedBox(height: 10),
                        _textCirle("Huinya"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 33),
                  InkWell(
                    onTap: () async {
                      userLevel>=4?await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(questionss: questions ), // Замените YourNewPage() на вашу новую страницу
                        ),
                      ):null;
                    },
                    child: Column(
                      children: <Widget>[
                        const CircleAvatarIndicator(Color(0xFF55acf3),
                            "assets/images/home_screen/lesson_baby.png"),
                        const SizedBox(height: 10),
                        _textCirle("idite nahui"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: <
                  Widget>[
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 15),
                      child: Divider(
                        color: Colors.black,
                        height: 50,
                      )),
                ),
                Image.asset(
                  "assets/images/home_screen/lesson_divisor_castle.png",
                  height: 85,
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 10),
                      child: Divider(
                        color: Colors.black,
                        height: 50,
                      )),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}