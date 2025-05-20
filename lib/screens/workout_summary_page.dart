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

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final calories = data['caloriesBurned'];
        final duration = data['duration'];

        if (calories is num) totalCalories += calories.toInt();
        if (duration is num) totalDuration += duration.toInt();

        workoutCount++;
      }

      return {
        'workouts': workoutCount,
        'caloriesBurnt': totalCalories,
        'duration': totalDuration,
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

          return Padding(
            padding: AppPaddings.all16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatCard('Total Workouts', totalWorkouts),
                const SizedBox(height: 12),
                _buildStatCard('Total Duration (min)', totalDuration),
                const SizedBox(height: 12),
                _buildStatCard('Total Calories Burned', totalCalories),
              ],
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
