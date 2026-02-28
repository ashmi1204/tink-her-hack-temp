import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DonorFormScreen extends StatefulWidget {
  const DonorFormScreen({super.key});

  @override
  State<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen> {
  final _foodController = TextEditingController();
  final _quantityController = TextEditingController();

Future<void> _uploadFood() async {
  try {
    // 1. Get Location
    Position position = await Geolocator.getCurrentPosition();

    // 2. Upload to Firestore
    await FirebaseFirestore.instance.collection('donations').add({
      'foodItem': _foodController.text,
      'quantity': _quantityController.text,
      'lat': position.latitude,
      'lng': position.longitude,
      'status': 'available',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 3. NEW: Clear the data entry points
    _foodController.clear();
    _quantityController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food posted! Ready for pickup.')),
      );
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donate Surplus Food")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _foodController, decoration: const InputDecoration(labelText: "Food Name")),
            TextField(controller: _quantityController, decoration: const InputDecoration(labelText: "Quantity")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _uploadFood, child: const Text("Post Donation")),
          ],
        ),
      ),
    );
  }
}