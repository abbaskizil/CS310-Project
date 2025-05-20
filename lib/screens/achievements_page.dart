import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  static const Map<String, IconData> _iconMap = {
    'fitness_center': Icons.fitness_center,
    'calendar_today': Icons.calendar_today,
    'directions_walk': Icons.directions_walk,
    'wb_sunny_outlined': Icons.wb_sunny_outlined,
    'star': Icons.star,
  };

  final defaultAchievements = [
    {
      'title': 'First Workout',
      'description': 'Complete your first workout session.',
      'icon': 'fitness_center',
      'completed': false,
      'progress': 0,
      'goal': 1,
    },
    {
      'title': 'Workout for 10 Hours',
      'description': 'Reach 10 hours of total workout time.',
      'icon': 'calendar_today',
      'completed': false,
      'progress': 0,
      'goal': 600, // in minutes
    },
    {
      'title': 'Burn 10,000 Calories',
      'description': 'Burn a total of 10,000 calories through workouts.',
      'icon': 'fitness_center',
      'completed': false,
      'progress': 0,
      'goal': 10000,
    },
    {
      'title': 'Morning Warrior',
      'description': 'Work out in the morning 10 times.',
      'icon': 'wb_sunny_outlined',
      'completed': false,
      'progress': 0,
      'goal': 10,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAchievementsIfNeeded();
  }

  Future<void> _initializeAchievementsIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final achievementsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('achievements');

    final snapshot = await achievementsRef.limit(1).get();
    if (snapshot.docs.isEmpty) {
      // Add default achievements if none exist yet
      for (final achievement in defaultAchievements) {
        await achievementsRef.add({...achievement, 'dateEarned': null});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Achievements')),
        body: const Center(
          child: Text('Please sign in to view your achievements.'),
        ),
      );
    }

    final achievementsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('achievements')
        .orderBy('dateEarned', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: achievementsRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Achievements')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Achievements')),
            body: const Center(
              child: Text(
                'No achievements yet.\nStart working out to earn some!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(title: const Text('Achievements')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final iconName = data['icon'] as String? ?? 'star';
                final icon = _iconMap[iconName] ?? Icons.star;

                // Fix: default incomplete to false to show progress correctly
                final isCompleted = data['completed'] as bool? ?? false;

                final progress = (data['progress'] as num?)?.toDouble() ?? 0;
                final goal = (data['goal'] as num?)?.toDouble() ?? 1;

                final progressRatio =
                    (goal > 0) ? (progress / goal).clamp(0.0, 1.0) : 0.0;

                return Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    leading: Icon(
                      icon,
                      size: 34,
                      color: isCompleted
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                    ),
                    title: Text(
                      data['title'] as String? ?? 'Achievement',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['description'] as String? ?? ''),
                        if (!isCompleted && goal > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: LinearProgressIndicator(
                              value: progressRatio,
                              backgroundColor: Colors.grey.shade300,
                              color: Theme.of(context).colorScheme.secondary,
                              minHeight: 6,
                            ),
                          ),
                        if (!isCompleted && goal > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${progress.toInt()} / ${goal.toInt()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                          ),
                      ],
                    ),
                    trailing: isCompleted
                        ? const Icon(Icons.check_circle_outline,
                            color: Colors.green)
                        : const Icon(Icons.lock_outline, color: Colors.grey),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) =>
                          _AchievementDetailSheet(achievement: data),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _AchievementDetailSheet extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const _AchievementDetailSheet({Key? key, required this.achievement})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            achievement['title'] ?? 'Achievement Detail',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            achievement['description'] ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (achievement['progress'] != null && achievement['goal'] != null)
            LinearProgressIndicator(
              value: ((achievement['progress'] as num).toDouble() /
                      (achievement['goal'] as num).toDouble())
                  .clamp(0.0, 1.0),
              minHeight: 8,
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                onPressed: () {
                  final title = achievement['title'] ?? 'My Achievement';
                  Share.share('I just unlocked: $title in AthleteTech! 🏆');
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
