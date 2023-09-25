import 'package:duolingo/src/home/main_screen/questions/question.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duolingo/src/home/main_screen/questions/models/question_class.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _databaseReference;
  bool _isLoading = true;
  String name = '';
  int userPoints = 0;
  String rank = '';
  String language = '';
  List<Question> recentMistakes = []; // List to store recent mistakes/questions

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      setState(() {
        _isLoading = true; // Установите состояние загрузки в true
      });
      final user = _auth.currentUser;
      if (user != null) {
        _databaseReference = FirebaseDatabase.instance.reference().child('users/${user.uid}');
        final dataSnapshot = await _databaseReference.once();
        final Map<dynamic, dynamic> data = dataSnapshot.snapshot.value;

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            name = data['Username'] ?? ''; // Provide a default value if 'Username' is null
            userPoints = data['points'] ?? 0; // Provide a default value if 'points' is null
            rank = data['rank'] ?? ''; // Provide a default value if 'rank' is null
            language = data['language'] ?? ''; // Provide a default value if 'language' is null
            // Load recent mistakes/questions from data (assuming it's stored in a list)
            recentMistakes = List<Question>.from(
              (data['mistakes'] ?? []).map(
                    (mistakeData) => Question(
                  question: (mistakeData['question'] ?? '').substring(2), // Начиная с третьего символа
                  options: List<String>.from(mistakeData['options'] ?? []),
                  correctAnswerIndex: mistakeData['correctAnswerIndex'] ?? 0,
                  questionType: QuestionType.values.firstWhere(
                        (e) => e.toString() == mistakeData['questionType'],
                    orElse: () => QuestionType.multipleChoice, // Предоставьте значение по умолчанию
                  ),
                  correctInputAns: mistakeData['correctInputAns'] ?? '',
                ),
              ),
            );
            _isLoading = false;
          });
        }
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _isLoading = false; // В случае ошибки также установите состояние загрузки в false
      });
    }
  }





  void _showQuestionDialog(Question question) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Answer:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              question.questionType == QuestionType.multipleChoice? Text(question.options[question.correctAnswerIndex]):Text(question.correctInputAns)
            ],
          ),
        );
      },
    );
  }
  Future<List<Question>> getPythonQuestions() async {
    final user = _auth.currentUser;
    final List<Question> pythonQuestions = [];
    if (user != null) {
      final useruid = user.uid;
      final databaseReference = FirebaseDatabase.instance.reference();
      final DatabaseEvent dataSnapshot = await databaseReference.child('users/$useruid/mistakes').once();

      final questionsData = dataSnapshot.snapshot.value as List<dynamic>;

      for (final questionData in questionsData) {
        final question = Question(
          question: (questionData['question']??"").substring(2),
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
      final DatabaseReference reference = FirebaseDatabase.instance.reference().child("users/$useruid/mistakes");
      reference.remove().then((_) {
        print('Папка успешно удалена');
      }).catchError((error) {
        print('Ошибка при удалении папки: $error');
      });
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionScreen(questionss: pythonQuestions,pointsto: 20, level:-1 ), // Замените YourNewPage() на вашу новую страницу
        ),
      );

    }
    return pythonQuestions;
  }


_titleText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );
  }

    @override
    Widget build(BuildContext context) => Scaffold(
        body: _isLoading?
            Center(child: CircularProgressIndicator())
            :SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 20,),
                    _titleText(name),
                    const SizedBox(width: 70),
                    ClipOval(
                      child: Image.asset(
                        userPoints>=400?"assets/images/ranks/r.png":userPoints>=350?"assets/images/ranks/i.png":userPoints>=300?"assets/images/ranks/a.png":userPoints>=250?"assets/images/ranks/d.png":userPoints>=200?"assets/images/ranks/p.png":userPoints>=150?"assets/images/ranks/g.png":userPoints>100?"assets/images/ranks/s.png":userPoints>=50?"assets/images/ranks/b.png":"assets/images/ranks/ir.png",
                        height: 120,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade500),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    _titleText("Information:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 50,
                            width: 170,
                            child: ListTile(
                                leading: Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Colors.amber,
                                ),
                                title: Text(
                                  "$userPoints",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                        ),
                        Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 50,
                            width: 170,
                            child: ListTile(
                                leading: Icon(
                                  Icons.language,
                                  color: Colors.amber,
                                ),
                                title: Text(
                                  "$language",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _titleText("Last mistakes"),
                        TextButton(
                            onPressed: (){
                              getPythonQuestions();
                            },
                            child: Text("Train"))
                      ],
                    ),
                    SizedBox(height: 10),
                    // List of recent mistakes/questions
                    ListView.builder(
                      shrinkWrap: true, // Add this line
                      itemCount: recentMistakes.length,
                      itemBuilder: (context, index) {
                        final question = recentMistakes[index];
                        return ListTile(
                          title: Text(question.question),
                          onTap: () {
                            // Show the question and its answer when tapped
                            _showQuestionDialog(question);
                          },
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
