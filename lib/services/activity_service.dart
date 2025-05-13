import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addActivity({
    required String type,
    required int duration,
    required int caloriesBurned,
    required String note,
    required DateTime scheduledDate,
    required int intensity,
    required String status
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    final docRef = _firestore.collection('workouts').doc();

    await docRef.set({
      'id': docRef.id,
      'type': type,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'intensity': intensity,
      'note': note,
      'status': status,
      'createdBy': uid,
      'createdAt': scheduledDate,
    });
  }
}
