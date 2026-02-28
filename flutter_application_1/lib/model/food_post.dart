class FoodPost {
  final String foodItem;
  final String quantity;
  final DateTime expiryTime;
  final double lat;
  final double lng;

  FoodPost({
    required this.foodItem,
    required this.quantity,
    required this.expiryTime,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodItem': foodItem,
      'quantity': quantity,
      'expiryTime': expiryTime,
      'lat': lat,
      'lng': lng,
      'status': 'available', // Default status
      'createdAt': DateTime.now(),
    };
  }
}