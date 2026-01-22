import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/user.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String currentUserId = '5'; // Current user's ID

  final List<LeaderboardUser> weeklyUsers = [
    LeaderboardUser(id: '1', name: 'Sarah Johnson', points: 2450, rank: 1),
    LeaderboardUser(id: '2', name: 'Mike Chen', points: 2380, rank: 2),
    LeaderboardUser(id: '3', name: 'Emma Davis', points: 2310, rank: 3),
    LeaderboardUser(id: '4', name: 'James Wilson', points: 2150, rank: 4),
    LeaderboardUser(id: '5', name: 'You', points: 2050, rank: 5),
    LeaderboardUser(id: '6', name: 'Lisa Anderson', points: 1980, rank: 6),
    LeaderboardUser(id: '7', name: 'Tom Martinez', points: 1850, rank: 7),
    LeaderboardUser(id: '8', name: 'Anna Lee', points: 1720, rank: 8),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryAction,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryAction,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardList(weeklyUsers),
          _buildLeaderboardList(weeklyUsers),
          _buildLeaderboardList(weeklyUsers),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardUser> users) {
    return Column(
      children: [
        // Top 3 podium
        _buildPodium(users.take(3).toList()),
        
        const SizedBox(height: 16),
        
        // Rest of the list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: users.length - 3,
            itemBuilder: (context, index) {
              final user = users[index + 3];
              final isCurrentUser = user.id == currentUserId;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? AppColors.softAccents.withOpacity(0.3)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: isCurrentUser
                      ? Border.all(color: AppColors.softAccents, width: 2)
                      : null,
                  boxShadow: [
                    if (!isCurrentUser)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    // Rank
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '#${user.rank}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryAction.withOpacity(0.2),
                      child: Text(
                        user.name[0],
                        style: const TextStyle(
                          color: AppColors.primaryAction,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Name
                    Expanded(
                      child: Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ),
                    
                    // Points
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${user.points}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primaryAction,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'points',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(List<LeaderboardUser> topThree) {
    if (topThree.length < 3) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          _buildPodiumCard(topThree[1], 2, 120, AppColors.secondary),
          
          const SizedBox(width: 8),
          
          // 1st place
          _buildPodiumCard(topThree[0], 1, 140, AppColors.primaryAction),
          
          const SizedBox(width: 8),
          
          // 3rd place
          _buildPodiumCard(topThree[2], 3, 100, AppColors.highlights),
        ],
      ),
    );
  }

  Widget _buildPodiumCard(LeaderboardUser user, int rank, double height, Color color) {
    IconData medalIcon;
    if (rank == 1) {
      medalIcon = Icons.emoji_events;
    } else if (rank == 2) {
      medalIcon = Icons.military_tech;
    } else {
      medalIcon = Icons.workspace_premium;
    }

    return Column(
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.softAccents,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(medalIcon, color: color, size: 32),
        ),
        
        const SizedBox(height: 8),
        
        // Avatar
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            user.name[0],
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Name
        SizedBox(
          width: 90,
          child: Text(
            user.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Points
        Text(
          '${user.points}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        
        const SizedBox(height: 8),
        
        // Podium
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
