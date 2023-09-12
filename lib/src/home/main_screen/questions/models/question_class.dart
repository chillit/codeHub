enum QuestionType {
  multipleChoice,
  textInput,
}

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final QuestionType questionType;
  final String correctInputAns;

  const Question({
    this.correctAnswerIndex,
    this.question,
    this.options,
    this.questionType = QuestionType.multipleChoice,
    this.correctInputAns,
  });
}
