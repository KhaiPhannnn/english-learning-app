class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonStatus status;
  final double progress; // 0.0 to 1.0
  final int totalWords;
  final int completedWords;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.totalWords,
    required this.completedWords,
  });
}

enum LessonStatus {
  locked,
  active,
  completed,
}
