import 'package:athletech/services/workout_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:athletech/services/social_feed_service.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth          = FirebaseAuth.instance;


  Future<void> addActivity({
    required String type,
    required int duration,
    required int caloriesBurned,
    required String note,
    required DateTime scheduledDate,
    required int intensity,
    required String status,
    bool shareToSocialFeed = false,
  }) async {

    final String? uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');


    final docRef = _firestore.collection('workouts').doc();


    final data = {
      'id'            : docRef.id,
      'type'          : type,
      'duration'      : duration,
      'caloriesBurned': caloriesBurned,
      'intensity'     : intensity,
      'note'          : note,
      'status'        : status,
      'createdBy'     : uid,
      'createdAt'     : scheduledDate,
    };


    await docRef.set(data);


    if (shareToSocialFeed) {
      await SocialFeedService().shareActivity(activityData: data);
    }
    await WorkoutService().updateAchievementProgress();

  }
}
