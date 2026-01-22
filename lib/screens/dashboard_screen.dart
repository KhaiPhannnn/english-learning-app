import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';
import '../widgets/progress_painter.dart';
import '../widgets/lesson_card.dart';
import '../providers/vocabulary_provider.dart';
import 'flashcard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  
  // Sample data
  final double dailyProgress = 0.65; // 65% complete
  
  final List<Lesson> lessons = [
    Lesson(
      id: '1',
      title: 'Basic Greetings',
      description: 'Learn common greetings and introductions',
      status: LessonStatus.completed,
      progress: 1.0,
      totalWords: 20,
      completedWords: 20,
    ),
    Lesson(
      id: '2',
      title: 'Daily Conversations',
      description: 'Master everyday English conversations',
      status: LessonStatus.active,
      progress: 0.6,
      totalWords: 30,
      completedWords: 18,
    ),
    Lesson(
      id: '3',
      title: 'Business English',
      description: 'Professional vocabulary and phrases',
      status: LessonStatus.active,
      progress: 0.3,
      totalWords: 40,
      completedWords: 12,
    ),
    Lesson(
      id: '4',
      title: 'Advanced Grammar',
      description: 'Complex sentence structures',
      status: LessonStatus.locked,
      progress: 0.0,
      totalWords: 50,
      completedWords: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<VocabularyProvider>(
      builder: (context, vocabularyProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning Path'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Daily Progress Section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Daily Progress',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      CircularProgress(
                        progress: dailyProgress,
                        size: 180,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Keep going! You are doing great!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Lessons Section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Lessons',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      // Review Library Card
                      _buildReviewLibraryCard(vocabularyProvider),
                      
                      // Regular lessons
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          return LessonCard(
                            lesson: lessons[index],
                            onTap: () {
                              // Navigate to lesson content
                              Navigator.of(context).pushNamed(AppRoutes.flashcard);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              switch (index) {
                case 0:
                  // Dashboard - already here
                  break;
                case 1:
                  Navigator.of(context).pushNamed(AppRoutes.quiz);
                  break;
                case 2:
                  Navigator.of(context).pushNamed(AppRoutes.leaderboard);
                  break;
                case 3:
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryAction,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'Quiz',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: 'Leaderboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewLibraryCard(VocabularyProvider vocabularyProvider) {
    final wordCount = vocabularyProvider.words.length;
    final status = wordCount > 0 ? LessonStatus.active : LessonStatus.locked;
    
    return GestureDetector(
      onTap: () {
        if (wordCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Add words to your library first!'),
              backgroundColor: AppColors.secondary,
            ),
          );
          return;
        }
        
        // Convert Words to Flashcards
        final flashcards = vocabularyProvider.words.map((word) {
          return Flashcard(
            id: word.id,
            word: word.term,
            pronunciation: '', // Empty for custom words
            definition: word.definition,
            example: '', // Empty for custom words
          );
        }).toList();
        
        // Navigate to flashcard screen with custom cards
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FlashcardScreen(
              customFlashcards: flashcards,
              title: 'Review Library',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            // Icon with background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softAccents.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.library_books,
                color: AppColors.secondary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review Library',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wordCount > 0
                        ? 'Practice your $wordCount custom ${wordCount == 1 ? "word" : "words"}'
                        : 'No words added yet',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            // Status indicator
            Icon(
              status == LessonStatus.active
                  ? Icons.check_circle
                  : Icons.lock_outline,
              color: status == LessonStatus.active
                  ? AppColors.secondary
                  : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}


