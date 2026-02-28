import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DonorFormScreen extends StatefulWidget {
  const DonorFormScreen({super.key});
  @override
  State<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _qtyController = TextEditingController();
  final _pickupController = TextEditingController();
  final _deadlineController = TextEditingController();
  bool _isUploading = false;

  Widget _buildField(String label, TextEditingController ctrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20), // Forest Green
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFFFC107)), // Mango Yellow
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _uploadFood() async {
    setState(() => _isUploading = true);
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
      // Uploading all new fields to food-collector-6a344
      await FirebaseFirestore.instance.collection('donations').add({
        'foodName': _nameController.text,
        'foodType': _typeController.text,
        'quantity': _qtyController.text,
        'pickupDetails': _pickupController.text,
        'deadline': _deadlineController.text,
        'lat': pos.latitude,
        'lng': pos.longitude,
        'status': 'available',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _typeController.clear();
      _qtyController.clear();
      _pickupController.clear();
      _deadlineController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food successfully posted!'), backgroundColor: Color(0xFF1B5E20)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posting Form")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField("Food Name", _nameController),
            _buildField("Food Type (Veg/Non-Veg)", _typeController),
            _buildField("Quantity", _qtyController),
            _buildField("Pickup Location/Details", _pickupController),
            _buildField("Pickup Deadline (e.g., 9 PM)", _deadlineController),
            const SizedBox(height: 20),
            // "Hug Content" Button
            Center(
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadFood,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: _isUploading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Post Donation"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}