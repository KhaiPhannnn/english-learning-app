import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/flashcard_screen.dart';
import '../screens/listening_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/vocabulary_library_screen.dart';

/// Route names
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String flashcard = '/flashcard';
  static const String listening = '/listening';
  static const String quiz = '/quiz';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String vocabularyLibrary = '/vocabulary-library';
}

/// Route generator
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.flashcard:
        return MaterialPageRoute(builder: (_) => const FlashcardScreen());
      case AppRoutes.listening:
        return MaterialPageRoute(builder: (_) => const ListeningScreen());
      case AppRoutes.quiz:
        return MaterialPageRoute(builder: (_) => const QuizScreen());
      case AppRoutes.leaderboard:
        return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.vocabularyLibrary:
        return MaterialPageRoute(
          builder: (_) => const VocabularyLibraryScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
