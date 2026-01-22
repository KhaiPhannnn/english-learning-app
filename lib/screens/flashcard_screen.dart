import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../config/theme.dart';
import '../models/quiz.dart';

class FlashcardScreen extends StatefulWidget {
  final List<Flashcard>? customFlashcards;
  final String? title;

  const FlashcardScreen({Key? key, this.customFlashcards, this.title})
    : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool showDefinition = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late List<Flashcard> flashcards;

  final List<Flashcard> _sampleFlashcards = [
    Flashcard(
      id: '1',
      word: 'Resilient',
      pronunciation: '/rɪˈzɪliənt/',
      definition: 'Able to recover quickly from difficulties',
      example: 'The resilient team overcame all obstacles.',
    ),
    Flashcard(
      id: '2',
      word: 'Eloquent',
      pronunciation: '/ˈeləkwənt/',
      definition: 'Fluent or persuasive speaking or writing',
      example: 'She gave an eloquent speech.',
    ),
    Flashcard(
      id: '3',
      word: 'Persevere',
      pronunciation: '/ˌpɜːrsəˈvɪr/',
      definition: 'Continue in a course of action despite difficulty',
      example: 'If you persevere, you will succeed.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Use custom flashcards if provided, otherwise use sample data
    flashcards = widget.customFlashcards ?? _sampleFlashcards;

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (showDefinition) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      showDefinition = !showDefinition;
    });
  }

  void _nextCard(bool know) {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        showDefinition = false;
        _flipController.reset();
      } else {
        // Show completion dialog
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great Job!'),
        content: const Text('You\'ve reviewed all flashcards!'),
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
                currentIndex = 0;
                showDefinition = false;
                _flipController.reset();
              });
            },
            child: const Text('Review Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show empty state if no flashcards
    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title ?? 'Flashcards')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              Text(
                'No words to review',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add words to your library first',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    final flashcard = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Flashcards'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '${currentIndex + 1}/${flashcards.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryAction,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / flashcards.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.highlights,
              ),
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
            ),

            const SizedBox(height: 32),

            // Flashcard
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * math.pi;
                    final transform = Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle);

                    return Transform(
                      transform: transform,
                      alignment: Alignment.center,
                      child: angle <= math.pi / 2
                          ? _buildFrontCard(flashcard)
                          : Transform(
                              transform: Matrix4.identity()..rotateY(math.pi),
                              alignment: Alignment.center,
                              child: _buildBackCard(flashcard),
                            ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _nextCard(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAction,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Review'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _nextCard(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Know'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(Flashcard flashcard) {
    return Card(
      elevation: 4,
      color: AppColors.softAccents,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              flashcard.word,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 32),
                  color: AppColors.primaryAction,
                  onPressed: () {
                    // Play pronunciation
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  flashcard.pronunciation,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Icon(Icons.touch_app, size: 48, color: AppColors.secondary),
            const SizedBox(height: 8),
            Text(
              'Tap to see definition',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard(Flashcard flashcard) {
    return Card(
      elevation: 4,
      color: AppColors.softAccents,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lightbulb_outline,
              size: 48,
              color: AppColors.primaryAction,
            ),
            const SizedBox(height: 24),
            Text(
              'Definition',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              flashcard.definition,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'Example',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${flashcard.example}"',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
