import 'package:flutter/material.dart';
import '../models/word.dart';

class VocabularyProvider extends ChangeNotifier {
  final List<Word> _words = [
    Word(
      id: '1',
      term: 'Eloquent',
      definition: 'Fluent or persuasive in speaking or writing',
    ),
    Word(
      id: '2',
      term: 'Resilient',
      definition:
          'Able to withstand or recover quickly from difficult conditions',
    ),
    Word(
      id: '3',
      term: 'Ubiquitous',
      definition: 'Present, appearing, or found everywhere',
    ),
  ];

  List<Word> get words => List.unmodifiable(_words);

  void addWord(Word word) {
    _words.add(word);
    notifyListeners();
  }

  void updateWord(String id, Word updatedWord) {
    final index = _words.indexWhere((word) => word.id == id);
    if (index != -1) {
      _words[index] = updatedWord;
      notifyListeners();
    }
  }

  void deleteWord(String id) {
    _words.removeWhere((word) => word.id == id);
    notifyListeners();
  }

  List<Word> searchWords(String query) {
    if (query.isEmpty) return words;

    final lowerQuery = query.toLowerCase();
    return _words.where((word) {
      return word.term.toLowerCase().contains(lowerQuery) ||
          word.definition.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
