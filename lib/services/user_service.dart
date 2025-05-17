import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserService {
  final _auth      = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Called right after sign-up to create the initial user doc.
  Future<void> createUserProfile({
    required String name,
    required String surname,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    await _firestore
       .collection('users')
       .doc(uid)
       .set({
         'name':        name,
         'surname':     surname,
         'email':       _auth.currentUser!.email,
         // defaults until the user edits them:
         'height':      0,
         'weight':      0,
         'age':         0,
         'gender':      'Unspecified',
         'memberSince': FieldValue.serverTimestamp(),
       }, SetOptions(merge: true));
  }

  Future<void> saveUserProfile({
    required String name,
    required String surname,
    required int    height,
    required int    weight,
    required int    age,
    required String gender,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    await _firestore
       .collection('users')
       .doc(uid)
       .set({
         'name':        name,
         'surname':     surname,
         'height':      height,
         'weight':      weight,
         'age':         age,
         'gender':      gender,
         'email':       _auth.currentUser!.email,
         'memberSince': FieldValue.serverTimestamp(),
       }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return _firestore.collection('users').doc(uid).get();
  }
}
