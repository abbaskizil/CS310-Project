import 'package:flutter/material.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievements = <Map<String, dynamic>>[
      {
        'title': 'First Workout',
        'description': 'Completed your very first workout!',
        'icon': Icons.fitness_center
      },
      {
        'title': 'Consistency Streak',
        'description': '7-day workout streak achieved.',
        'icon': Icons.calendar_today
      },
      {
        'title': 'Step Master',
        'description': 'Hit 10 000 steps in one day.',
        'icon': Icons.directions_walk
      },
      {
        'title': 'Early Bird',
        'description': 'Logged a workout before 7 AM.',
        'icon': Icons.wb_sunny_outlined
      },
      // add more …
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: achievements.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = achievements[index];
            return Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  size: 34,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  item['title'] as String,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(item['description'] as String),
                trailing: const Icon(Icons.chevron_right_rounded),
                // 👉 tap again for a detailed breakdown or share screen, etc.
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}
