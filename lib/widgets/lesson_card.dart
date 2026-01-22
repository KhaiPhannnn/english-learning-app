import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: lesson.status == LessonStatus.locked ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status icon
              _buildStatusIcon(),
              const SizedBox(width: 16),
              
              // Lesson info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    if (lesson.status != LessonStatus.locked)
                      LinearProgressIndicator(
                        value: lesson.progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          lesson.status == LessonStatus.completed
                              ? AppColors.secondary
                              : AppColors.primaryAction,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '${lesson.completedWords}/${lesson.totalWords} words',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              // Arrow or lock icon
              Icon(
                lesson.status == LessonStatus.locked
                    ? Icons.lock_outline
                    : Icons.arrow_forward_ios,
                color: lesson.status == LessonStatus.locked
                    ? Colors.grey
                    : AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    Color backgroundColor;
    IconData icon;
    Color iconColor;

    switch (lesson.status) {
      case LessonStatus.locked:
        backgroundColor = Colors.grey.shade300;
        icon = Icons.lock;
        iconColor = Colors.grey;
        break;
      case LessonStatus.active:
        backgroundColor = AppColors.secondary.withOpacity(0.2);
        icon = Icons.play_circle_outline;
        iconColor = AppColors.secondary;
        break;
      case LessonStatus.completed:
        backgroundColor = AppColors.softAccents.withOpacity(0.3);
        icon = Icons.check_circle;
        iconColor = AppColors.primaryAction;
        break;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 28),
    );
  }
}
