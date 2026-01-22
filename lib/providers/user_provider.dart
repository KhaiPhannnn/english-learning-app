import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // Login user
  void login(String email, String password) {
    // In a real app, you would validate credentials with backend
    _currentUser = User(
      id: '1',
      name: 'User',
      email: email,
      totalWords: 1250,
      streak: 15,
      points: 2050,
      achievements: ['beginner', 'consistent', 'word_master'],
      dailyProgress: 0.65,
    );
    notifyListeners();
  }

  // Signup user
  void signup(String name, String email, String password) {
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      totalWords: 0,
      streak: 0,
      points: 0,
      achievements: [],
      dailyProgress: 0.0,
    );
    notifyListeners();
  }

  // Update profile
  void updateProfile({String? name, String? email, String? avatarUrl}) {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
        totalWords: _currentUser!.totalWords,
        streak: _currentUser!.streak,
        points: _currentUser!.points,
        achievements: _currentUser!.achievements,
        dailyProgress: _currentUser!.dailyProgress,
      );
      notifyListeners();
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
