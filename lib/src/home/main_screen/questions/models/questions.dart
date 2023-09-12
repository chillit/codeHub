import 'package:duolingo/src/home/main_screen/questions/models/question_class.dart';

List<Question> questions = [
  Question(
    question: '1. What is the capital of France?',
    correctAnswerIndex: 1,
    options: [
      'Madrid',
      'Paris',
      'Berlin',
      'Rome',
    ],
  ),
  Question(
    question: '2. What is the capital of Italy?',
    correctAnswerIndex: 3,
    options: [
      'Madrid',
      'Paris',
      'Berlin',
      'Rome',
    ],
  ),
  Question(
    question: '3. What is your favorite color?',
    correctAnswerIndex: null,
    questionType: QuestionType.textInput,
    correctInputAns: 'black',
  ),
  Question(
    question: '3. What is your favorite color?',
    correctAnswerIndex: null,
    questionType: QuestionType.textInput,
    correctInputAns: 'black',
  ),
  Question(
    question: '4. Which planet is known as the Red Planet?',
    correctAnswerIndex: 0,
    options: [
      'Mars',
      'Venus',
      'Jupiter',
      'Saturn',
    ],
  ),
  Question(
    question: '5. Who wrote the play "Romeo and Juliet"?',
    correctAnswerIndex: 1,
    options: [
      'Charles Dickens',
      'William Shakespeare',
      'Jane Austen',
      'Leo Tolstoy',
    ],
  ),
  Question(
    question: '6. Which gas do plants absorb from the atmosphere?',
    correctAnswerIndex: 2,
    options: [
      'Oxygen',
      'Carbon monoxide',
      'Carbon dioxide',
      'd) Nitrogen',
    ],
  ),
  Question(
    question: '7. What is the largest mammal on Earth?',
    correctAnswerIndex: 3,
    options: [
      'African elephant',
      'Blue whale',
      'Giraffe',
      'Polar bear',
    ],
  ),
  Question(
    question: '8. Who painted the Mona Lisa?',
    correctAnswerIndex: 0,
    options: [
      'Leonardo da Vinci',
      'Pablo Picasso',
      'Vincent van Gogh',
      'Michelangelo',
    ],
  ),
  // Add more questions here...
];
