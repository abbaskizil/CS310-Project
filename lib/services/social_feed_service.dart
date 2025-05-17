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
    .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,       // <-- add the id here
          ...data,            // <-- merge in all your other fields
        };
      }).toList();
    });
}
  
  Stream<List<Map<String, dynamic>>> getComments(String postId) {
    return _firestore
        .collection('social_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
  /// 2) Add a new comment to that post:
  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    final uid  = _auth.currentUser?.uid;
    final name = _auth.currentUser?.displayName ?? 'Anon';
    print('Adding comment to post $postId: $text by $uid');
    await _firestore
      .collection('social_posts')
      .doc(postId)
      .collection('comments')      // ← this must match your UI’s getComments path
      .add({
        'uid':       uid,
        'username':  name,
        'text':      text,
        'createdAt': FieldValue.serverTimestamp(),
      });
    print('✅ comment written');
  }
}
