class Quiz {
  final String id;
  final String title;
  final List<Question> questions;
  final int totalQuestions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
    required this.totalQuestions,
  });
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}

class Flashcard {
  final String id;
  final String word;
  final String pronunciation;
  final String definition;
  final String example;
  final String? audioUrl;

  Flashcard({
    required this.id,
    required this.word,
    required this.pronunciation,
    required this.definition,
    required this.example,
    this.audioUrl,
  });
}
