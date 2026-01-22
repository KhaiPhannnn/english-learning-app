import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/quiz.dart';
import '../widgets/custom_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  int score = 0;
  bool hasAnswered = false;

  final List<Question> questions = [
    Question(
      id: '1',
      text: 'What is the past tense of "go"?',
      options: ['goed', 'went', 'gone', 'going'],
      correctAnswerIndex: 1,
      explanation: '"Went" is the correct past tense of "go".',
    ),
    Question(
      id: '2',
      text: 'Which word is a synonym of "happy"?',
      options: ['sad', 'joyful', 'angry', 'tired'],
      correctAnswerIndex: 1,
      explanation: '"Joyful" means feeling great happiness.',
    ),
    Question(
      id: '3',
      text: 'Choose the correct article: "__ apple a day"',
      options: ['A', 'An', 'The', 'No article'],
      correctAnswerIndex: 1,
      explanation: '"An" is used before words starting with a vowel sound.',
    ),
    Question(
      id: '4',
      text: 'What does "procrastinate" mean?',
      options: [
        'To act quickly',
        'To delay or postpone',
        'To complete tasks',
        'To organize',
      ],
      correctAnswerIndex: 1,
      explanation: 'Procrastinate means to delay or postpone action.',
    ),
  ];

  void _selectOption(int index) {
    if (!hasAnswered) {
      setState(() {
        selectedOptionIndex = index;
      });
    }
  }

  void _submitAnswer() {
    if (selectedOptionIndex == null) return;

    setState(() {
      hasAnswered = true;
      if (selectedOptionIndex == questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        hasAnswered = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              score >= questions.length * 0.7 ? Icons.emoji_events : Icons.thumb_up,
              size: 64,
              color: AppColors.softAccents,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '$score / ${questions.length}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primaryAction,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${((score / questions.length) * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.secondary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                selectedOptionIndex = null;
                score = 0;
                hasAnswered = false;
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.highlights),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} of ${questions.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Score: $score',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryAction,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      question.text,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Options
                  ...List.generate(question.options.length, (index) {
                    final isSelected = selectedOptionIndex == index;
                    final isCorrect = index == question.correctAnswerIndex;
                    Color borderColor;
                    Color backgroundColor;

                    if (!hasAnswered) {
                      borderColor = isSelected ? AppColors.secondary : Colors.grey.shade300;
                      backgroundColor = isSelected
                          ? AppColors.secondary.withOpacity(0.1)
                          : Colors.white;
                    } else {
                      if (isCorrect) {
                        borderColor = Colors.green;
                        backgroundColor = Colors.green.withOpacity(0.1);
                      } else if (isSelected && !isCorrect) {
                        borderColor = AppColors.primaryAction;
                        backgroundColor = AppColors.primaryAction.withOpacity(0.1);
                      } else {
                        borderColor = Colors.grey.shade300;
                        backgroundColor = Colors.white;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => _selectOption(index),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  color: isSelected || (hasAnswered && isCorrect)
                                      ? borderColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D
                                    style: TextStyle(
                                      color: isSelected || (hasAnswered && isCorrect)
                                          ? Colors.white
                                          : borderColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              if (hasAnswered && isCorrect)
                                const Icon(Icons.check_circle, color: Colors.green),
                              if (hasAnswered && isSelected && !isCorrect)
                                const Icon(Icons.cancel, color: AppColors.primaryAction),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Explanation
                  if (hasAnswered && question.explanation != null)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.softAccents.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline, color: AppColors.secondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.explanation!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Submit/Next button
                  if (!hasAnswered)
                    CustomButton(
                      text: 'Submit',
                      onPressed: selectedOptionIndex != null ? _submitAnswer : () {},
                      backgroundColor: selectedOptionIndex != null
                          ? AppColors.primaryAction
                          : Colors.grey,
                    )
                  else
                    CustomButton(
                      text: currentQuestionIndex < questions.length - 1
                          ? 'Next Question'
                          : 'See Results',
                      onPressed: _nextQuestion,
                      backgroundColor: AppColors.secondary,
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
