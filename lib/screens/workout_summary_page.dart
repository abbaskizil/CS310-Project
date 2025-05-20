import 'package:athletech/utilities/colors.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutSummaryPage extends StatefulWidget {
  const WorkoutSummaryPage({super.key});

  @override
  State<WorkoutSummaryPage> createState() => _WorkoutSummaryPageState();
}

class _WorkoutSummaryPageState extends State<WorkoutSummaryPage> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStatsFromFirestore();
  }

  Future<Map<String, dynamic>> _loadStatsFromFirestore() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .where('createdBy', isEqualTo: uid)
          .where('status', isEqualTo: 'Completed')
          .get();

      int totalCalories = 0;
      int totalDuration = 0;
      int workoutCount = 0;
      List<Map<String, dynamic>> activityDetails = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final calories = data['caloriesBurned'];
        final duration = data['duration'];
        final type = data['type'] ?? 'Workout';
        final note = data['note'] ?? '';

        if (calories is num) totalCalories += calories.toInt();
        if (duration is num) totalDuration += duration.toInt();

        workoutCount++;

        activityDetails.add({
          'title': type,
          'duration': duration,
          'calories': calories,
          'note': note,
        });
      }

      return {
        'workouts': workoutCount,
        'caloriesBurnt': totalCalories,
        'duration': totalDuration,
        'activities': activityDetails,
      };
    } catch (e) {
      debugPrint("WorkoutSummary error: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Summary', style: kAppBarTitleTextStyle),
        backgroundColor: AppColors.appBarColor,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data ?? {};
          final totalWorkouts = _safeToInt(stats['workouts']);
          final totalCalories = _safeToInt(stats['caloriesBurnt']);
          final totalDuration = _safeToInt(stats['duration']);
          final List activities = stats['activities'] ?? [];

          return Padding(
            padding: AppPaddings.all16,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activities.isNotEmpty) ...[
                    Text('Activities:', style: kButtonLightTextStyle.copyWith(fontSize: 16)),
                    const SizedBox(height: 10),
                    ...activities.map((activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('Duration: ${activity['duration']} min'),
                            if (activity['calories'] != null && activity['calories'] > 0)
                              Text('Calories: ${activity['calories']}'),
                            if (activity['note'] != null && activity['note'].toString().isNotEmpty)
                              Text('Notes: ${activity['note']}'),
                          ],
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _safeToInt(dynamic value) {
    try {
      if (value == null) return '0';
      if (value is int) return value.toString();
      if (value is double) return value.toInt().toString();
      if (value is num) return value.toInt().toString();
      return int.tryParse(value.toString())?.toString() ?? '0';
    } catch (e) {
      debugPrint("Conversion error: $e");
      return '0';
    }
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: AppPaddings.all16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: kButtonLightTextStyle.copyWith(fontSize: 16)),
            Text(value, style: kButtonLightTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
