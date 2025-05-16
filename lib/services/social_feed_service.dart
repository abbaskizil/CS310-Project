import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialFeedService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth          = FirebaseAuth.instance;


  Future<void> shareActivity({
    required Map<String, dynamic> activityData,
  }) async {

    final String? uid   = _auth.currentUser?.uid;
    final String  uname = _auth.currentUser?.displayName ?? 'Anonymous';

    if (uid == null) {
      throw Exception('User not logged in');
    }


    final docRef = _firestore.collection('social_posts').doc();


    await docRef.set({
      'id'       : docRef.id,
      'userId'   : uid,
      'userName' : uname,
      ...activityData,
      'createdAt': DateTime.now(),
    });
  }


  Stream<List<Map<String, dynamic>>> getPosts() {
    return _firestore
        .collection('social_posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => doc.data())
          .toList(),
    );
  }
}
