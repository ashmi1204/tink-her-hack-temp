import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/food_post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFoodPost(FoodPost post) async {
    await _db.collection('food_posts').add(post.toMap());
  }
}