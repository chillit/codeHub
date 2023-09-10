import 'package:duolingo/src/home/main_screen/questions/models/questions.dart';
import 'package:flutter/material.dart';
import 'package:duolingo/src/home/main_screen/questions/models/question_class.dart';
import 'package:duolingo/src/home/main_screen/questions/models/result_screen.dart';

class QuestionScreen extends StatefulWidget {
  final List<Question> questionss;

  QuestionScreen({this.questionss});

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
    currentQuestions = List.from(questions);
  }

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

    if (allQuestionsAnswered) {
      return ResultScreen(score: correctAnswersCount, len: totalQuestionsCount);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.red, // Set the color of the back arrow to red
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
          Text(question.question),
          if (question.questionType == QuestionType.multipleChoice)
            MultipleChoiceQuestion(
              questions: currentQuestions,
              question: question,
              onNextQuestion: () {
                goToNextQuestion();
              },
              onAnswerCorrect: () {
                setState(() {
                  correctAnswersCount++;
                });
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
                setState(() {
                  correctAnswersCount++;
                });
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

  MultipleChoiceQuestion({this.question, this.onNextQuestion, this.onAnswerCorrect,this.questions});

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  int selectedOptionIndex;
  bool isAnswerCorrect = false;

  void _showResultDialog(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Запрещаем закрытие при нажатии вне окна
      builder: (BuildContext context) {
        return Container(
          color: isCorrect?Colors.green:Colors.red,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCorrect ? 'Correct Answer' : 'Incorrect Answer',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                isCorrect
                    ? 'Congratulations! Your answer is correct.'
                    : 'Correct answer:${widget.question.options[widget.question.correctAnswerIndex]}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onNextQuestion(); // Перейти к следующему вопросу
                  },
                  child: Text('Next Question'),
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
              final color = isSelected ? Colors.blue : null;

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
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: color,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}', // Отображаем номер ответа
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(width: 8.0), // Добавляем пространство между номером и текстом
                      Expanded(
                        child: Text(
                          option,
                          textAlign: TextAlign.center, // Выравниваем текст по центру
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16.0,
                          ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7e4a3b),
                  ),
                  onPressed: () {
                    skip();
                  },
                  child: Text('Skip'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7e4a3b),
                  ),
                  onPressed: () {
                    checkAnswer();
                  },
                  child: Text('Check Answer'),
                ),
              ),
              SizedBox(height: 12.0),
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
        // Append the current question to the end of the questions list
        setState(() {
          widget.questions.add(widget.question);
        });
      }

      _showResultDialog(isCorrect);
    }
  }
  void skip(){
    setState(() {
      widget.questions.add(widget.question);
    });
    _showResultDialog(false);
  }

}

class TextInputQuestion extends StatefulWidget {
  final List<Question> questions;
  final Question question;
  final Function() onNextQuestion;
  final Function() onAnswerCorrect;

  TextInputQuestion({this.question, this.onNextQuestion, this.onAnswerCorrect,this.questions});

  @override
  _TextInputQuestionState createState() => _TextInputQuestionState();
}

class _TextInputQuestionState extends State<TextInputQuestion> {
  final TextEditingController answerController = TextEditingController();
  bool isAnswerCorrect;

  void _showResultDialog(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Запрещаем закрытие при нажатии вне окна
      builder: (BuildContext context) {
        return Container(
          color: isCorrect?Colors.green:Colors.red,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCorrect ? 'Correct Answer' : 'Incorrect Answer',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                isCorrect
                    ? 'Congratulations! Your answer is correct.'
                    : 'Correct answer:${widget.question.correctInputAns}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onNextQuestion(); // Перейти к следующему вопросу
                  },
                  child: Text('Next Question'),
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
          TextField(
            controller: answerController,
            decoration: InputDecoration(
                labelText: 'Your Answer',
                filled: true,
                fillColor: Colors.transparent
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color(0xFF7e4a3b)
                  ),
                  onPressed: () {
                    skip();
                  },
                  child: Text('Skip'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7e4a3b)
                  ),
                  onPressed: () {
                    checkAnswer();
                  },
                  child: Text('Check Answer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void skip(){
    setState(() {
      widget.questions.add(widget.question);
    });
    _showResultDialog(false);
  }
  void checkAnswer() {
    final userAnswer = answerController.text;
    bool isCorrect = userAnswer == widget.question.correctInputAns;
    setState(() {
      isAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      widget.onAnswerCorrect(); // Increase the correct answers count
    } else {
      // Append the current question to the end of the questions list
      setState(() {
        widget.questions.add(widget.question);
      });
    }

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
