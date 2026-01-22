import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user =
            userProvider.currentUser ??
            User(
              id: '1',
              name: 'Guest User',
              email: 'guest@example.com',
              totalWords: 0,
              streak: 0,
              points: 0,
              achievements: [],
              dailyProgress: 0.0,
            );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.primaryAction,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              Icons.whatshot,
                              '${user.streak}',
                              'Day Streak',
                              AppColors.primaryAction,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              Icons.book,
                              '${user.totalWords}',
                              'Words Learned',
                              AppColors.secondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              Icons.star,
                              '${user.points}',
                              'Total Points',
                              AppColors.highlights,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              Icons.emoji_events,
                              '${user.achievements.length}',
                              'Achievements',
                              AppColors.softAccents,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Weekly Progress
                      Text(
                        'Weekly Progress',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 16),

                      Container(
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
                        child: Column(
                          children: [
                            // Simple bar chart
                            SizedBox(
                              height: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBarChart(context, 'Mon', 0.6),
                                  _buildBarChart(context, 'Tue', 0.8),
                                  _buildBarChart(context, 'Wed', 0.7),
                                  _buildBarChart(context, 'Thu', 0.9),
                                  _buildBarChart(context, 'Fri', 0.75),
                                  _buildBarChart(context, 'Sat', 0.5),
                                  _buildBarChart(context, 'Sun', 0.85),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Achievements
                      Text(
                        'Achievements',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 16),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _buildAchievementBadge(
                            context,
                            Icons.emoji_events,
                            'Beginner',
                            true,
                          ),
                          _buildAchievementBadge(
                            context,
                            Icons.local_fire_department,
                            'Consistent',
                            true,
                          ),
                          _buildAchievementBadge(
                            context,
                            Icons.school,
                            'Word Master',
                            true,
                          ),
                          _buildAchievementBadge(
                            context,
                            Icons.speed,
                            'Speed Learner',
                            false,
                          ),
                          _buildAchievementBadge(
                            context,
                            Icons.verified,
                            'Expert',
                            false,
                          ),
                          _buildAchievementBadge(
                            context,
                            Icons.workspace_premium,
                            'Legend',
                            false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Settings
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 16),

                      _buildSettingTile(
                        context,
                        Icons.edit_outlined,
                        'Edit Profile',
                        () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.editProfile);
                        },
                      ),
                      _buildSettingTile(
                        context,
                        Icons.library_books_outlined,
                        'My Library',
                        () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.vocabularyLibrary);
                        },
                      ),
                      _buildSettingTile(
                        context,
                        Icons.notifications_outlined,
                        'Notifications',
                        () {},
                      ),
                      _buildSettingTile(
                        context,
                        Icons.language_outlined,
                        'Language',
                        () {},
                      ),
                      _buildSettingTile(
                        context,
                        Icons.privacy_tip_outlined,
                        'Privacy',
                        () {},
                      ),
                      _buildSettingTile(
                        context,
                        Icons.help_outline,
                        'Help & Support',
                        () {},
                      ),
                      _buildSettingTile(context, Icons.logout, 'Logout', () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: AppColors.primaryAction,
                                ),
                                const SizedBox(width: 12),
                                const Text('Confirm Logout'),
                              ],
                            ),
                            content: const Text(
                              'Are you sure you want to log out of your account?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed(AppRoutes.login);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAction,
                                  elevation: 2,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      }, isDestructive: true),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, String day, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: value * 120,
          decoration: BoxDecoration(
            color: AppColors.primaryAction,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    IconData icon,
    String label,
    bool unlocked,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? AppColors.softAccents.withOpacity(0.3)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: unlocked ? AppColors.softAccents : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: unlocked ? AppColors.primaryAction : Colors.grey,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
              color: unlocked ? AppColors.textPrimary : Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.primaryAction : AppColors.secondary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDestructive ? AppColors.primaryAction : null,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
