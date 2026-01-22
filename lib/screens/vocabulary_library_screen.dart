import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/word.dart';
import '../providers/vocabulary_provider.dart';

class VocabularyLibraryScreen extends StatefulWidget {
  const VocabularyLibraryScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyLibraryScreen> createState() =>
      _VocabularyLibraryScreenState();
}

class _VocabularyLibraryScreenState extends State<VocabularyLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEditDialog({Word? word}) {
    final isEditing = word != null;
    final termController = TextEditingController(text: word?.term ?? '');
    final definitionController = TextEditingController(
      text: word?.definition ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit : Icons.add_circle,
                      color: AppColors.primaryAction,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Edit Word' : 'Add New Word',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Term field
                TextFormField(
                  controller: termController,
                  decoration: InputDecoration(
                    labelText: 'Word/Term',
                    hintText: 'Enter the word',
                    prefixIcon: const Icon(
                      Icons.abc,
                      color: AppColors.secondary,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a word';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Definition field
                TextFormField(
                  controller: definitionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Definition',
                    hintText: 'Enter the definition',
                    prefixIcon: const Icon(
                      Icons.description,
                      color: AppColors.secondary,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.secondary.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a definition';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Save button
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final provider = Provider.of<VocabularyProvider>(
                        context,
                        listen: false,
                      );

                      if (isEditing) {
                        provider.updateWord(
                          word.id,
                          word.copyWith(
                            term: termController.text,
                            definition: definitionController.text,
                          ),
                        );
                      } else {
                        provider.addWord(
                          Word(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            term: termController.text,
                            definition: definitionController.text,
                          ),
                        );
                      }

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing ? 'Word updated!' : 'Word added!',
                          ),
                          backgroundColor: AppColors.secondary,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAction,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? 'Update Word' : 'Add Word',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Word word) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.primaryAction),
            const SizedBox(width: 12),
            const Text('Delete Word'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${word.term}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<VocabularyProvider>(
                context,
                listen: false,
              ).deleteWord(word.id);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${word.term} deleted'),
                  backgroundColor: AppColors.primaryAction,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAction,
              elevation: 2,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search your vocabulary...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.secondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: AppColors.secondary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Vocabulary List
          Expanded(
            child: Consumer<VocabularyProvider>(
              builder: (context, provider, child) {
                final words = _searchQuery.isEmpty
                    ? provider.words
                    : provider.searchWords(_searchQuery);

                if (words.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.library_books
                              : Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No words yet'
                              : 'No words found',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tap + to add your first word'
                              : 'Try a different search term',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          word.term,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.primaryAction,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            word.definition,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              color: AppColors.secondary,
                              onPressed: () => _showAddEditDialog(word: word),
                            ),
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppColors.primaryAction,
                              onPressed: () =>
                                  _showDeleteConfirmation(context, word),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: AppColors.primaryAction,
        elevation: 4,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
