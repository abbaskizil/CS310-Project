import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String name,
    required String surname,
    required int height,
    required int weight,
    required int age,
    required String gender,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'surname': surname,
      'height': height,
      'weight': weight,
      'age': age,
      'gender': gender,
      'email': _auth.currentUser!.email,
      'memberSince': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return await _firestore.collection('users').doc(uid).get();
  }
}
