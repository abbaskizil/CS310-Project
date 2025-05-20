import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Fetch stats like total workouts, total calories burned, and total workout duration
  Future<Map<String, dynamic>> getUserStats() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snapshot =
        await _firestore
            .collection('workouts')
            .where('createdBy', isEqualTo: uid)
            .where(
              'status',
              isEqualTo: 'Completed',
            ) // Filter completed workouts
            .get();

    int totalCalories = 0;
    int totalDuration = 0;
    int workoutCount = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data['status'] == 'Completed') {
        totalDuration += (data['duration'] ?? 0) as int;
        totalCalories += (data['caloriesBurned'] ?? 0) as int;
        workoutCount = workoutCount + 1;
      }
    }

    // Fetch the total calories taken (from the 'calories' collection)
    final totalCaloriesTaken = await _getTotalCaloriesTaken(uid);

    return {
      'workouts': workoutCount,
      'caloriesBurnt': totalCalories,
      'caloriesTaken': totalCaloriesTaken,
      'duration': totalDuration, // Duration in minutes
    };
  }

  // Fetch total calories taken by the user
  Future<int> _getTotalCaloriesTaken(String uid) async {
    final snapshot =
        await _firestore
            .collection('calories')
            .where('createdBy', isEqualTo: uid)
            .get();

    int totalCalories = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      totalCalories += (data['calories'] ?? 0) as int;
    }

    return totalCalories;
  }

  Future<void> updateAchievementProgress() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final achievementsRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('achievements');

    final workoutsSnapshot = await _firestore
        .collection('workouts')
        .where('createdBy', isEqualTo: uid)
        .get();

    final workouts = workoutsSnapshot.docs.map((doc) => doc.data()).toList();

    int totalDuration = 0;
    int totalCalories = 0;
    int morningWorkouts = 0;

    for (final workout in workouts) {
      final date = (workout['createdAt'] as Timestamp).toDate();
      totalDuration += workout['duration'] as int? ?? 0;
      totalCalories += workout['caloriesBurned'] as int? ?? 0;

      if (date.hour < 12) {
        morningWorkouts += 1;
      }
    }

    final achievementDocs = await achievementsRef.get();

    for (final doc in achievementDocs.docs) {
      final data = doc.data();
      final title = data['title'];

      int progress = 0;
      int goal = data['goal'] ?? 1;
      bool completed = false;

      switch (title) {
        case 'First Workout':
          progress = workouts.isNotEmpty ? 1 : 0;
          completed = progress >= goal;
          break;
        case 'Workout for 10 Hours':
          progress = totalDuration;
          completed = progress >= goal;
          break;
        case 'Burn 10,000 Calories':
          progress = totalCalories;
          completed = progress >= goal;
          break;
        case 'Morning Warrior':
          progress = morningWorkouts;
          completed = progress >= goal;
          break;
        default:
          continue;
      }

      await achievementsRef.doc(doc.id).update({
        'progress': progress,
        'completed': completed,
        'dateEarned': completed && data['dateEarned'] == null
            ? Timestamp.now()
            : data['dateEarned'],
      });
    }
  }

}
