// class FoodPost {
//   final String foodItem;
//   final String quantity;
//   final DateTime expiryTime;
//   final double lat;
//   final double lng;

//   FoodPost({
//     required this.foodItem,
//     required this.quantity,
//     required this.expiryTime,
//     required this.lat,
//     required this.lng,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'foodItem': foodItem,
//       'quantity': quantity,
//       'expiryTime': expiryTime,
//       'lat': lat,
//       'lng': lng,
//       'status': 'available', // Default status
//       'createdAt': DateTime.now(),
//     };
//   }
// }

class FoodPost {
  final String id;
  final String foodName;
  final String foodType;
  final int quantity;
  final String location;
  final String status;
  final DateTime timestamp;

  FoodPost({
    required this.id,
    required this.foodName,
    required this.foodType,
    required this.quantity,
    required this.location,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'foodType': foodType,
      'quantity': quantity,
      'location': location,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory FoodPost.fromMap(String id, Map<String, dynamic> map) {
    return FoodPost(
      id: id,
      foodName: map['foodName'],
      foodType: map['foodType'],
      quantity: map['quantity'],
      location: map['location'],
      status: map['status'],
      timestamp: map['timestamp'].toDate(),
    );
  }
}