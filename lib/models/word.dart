class Word {
  final String id;
  final String term;
  final String definition;
  final DateTime createdAt;

  Word({
    required this.id,
    required this.term,
    required this.definition,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Word copyWith({
    String? id,
    String? term,
    String? definition,
    DateTime? createdAt,
  }) {
    return Word(
      id: id ?? this.id,
      term: term ?? this.term,
      definition: definition ?? this.definition,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
