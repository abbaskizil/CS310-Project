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
}
