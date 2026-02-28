// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../model/food_post.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<void> addFoodPost(FoodPost post) async {
//     await _db.collection('food_posts').add(post.toMap());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food_post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFoodPost(FoodPost post) async {
    await _db.collection('donations').add(post.toMap());
  }

  Stream<QuerySnapshot> getAvailableFood() {
    return _db
        .collection('donations')
        .where('status', isEqualTo: 'available')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markAsAccepted(String docId) async {
    await _db.collection('donations').doc(docId).update({
      'status': 'accepted',
    });
  }
}