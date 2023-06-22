class QuestionModel {
  String text;
  String category;
  String difficulty;
  String correctAnswer;
  List<String> answers;

  QuestionModel({
    required this.text,
    required this.category,
    required this.difficulty,
    required this.correctAnswer,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {

    return QuestionModel(
      text: json['question']['text'],
      category: json['category'],
      difficulty: json['difficulty'],
      correctAnswer: json['correctAnswer'],
      answers: (json['incorrectAnswers'] as List<dynamic>).cast<String>(),
    );
  }
}

