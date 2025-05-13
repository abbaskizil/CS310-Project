import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/calorie_tracker.dart'; // Assuming you have the CalorieEntry class in a separate file

class CalorieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new calorie entry
  Future<void> addCalorieEntry(CalorieEntry entry) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection('calories').doc();
    await docRef.set(entry.toFirestore(uid));
  }

  // Remove a calorie entry
  Future<void> removeCalorieEntry(String id) async {
    await _firestore.collection('calories').doc(id).delete();
  }

  // Stream all calorie entries for the current user
Stream<List<CalorieEntry>> getCalorieEntries() {
  final uid = _auth.currentUser?.uid;
  if (uid == null) return const Stream.empty();

  // No `orderBy` here, so it fetches the documents as they come
  return _firestore
      .collection('calories')
      .where('createdBy', isEqualTo: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CalorieEntry.fromFirestore(doc.data(), doc.id))
          .toList());
}
}
