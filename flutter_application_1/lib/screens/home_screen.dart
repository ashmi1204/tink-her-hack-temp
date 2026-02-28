import 'package:flutter/material.dart';
import 'donor_form_screen.dart';
import 'available_food_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RESERVE", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Branding Section
            const Icon(Icons.eco, size: 100, color: Color(0xFF1B5E20)),
            const SizedBox(height: 10),
            const Text(
              "Reserve",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
            ),
            const Text(
              "Reserve the surplus, Feed the future",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 50),

            // Navigation Buttons
            _buildHomeButton(
              context, 
              "Donate Food", 
              Icons.volunteer_activism, 
              const DonorFormScreen(), 
              isGreen: true
            ),
            const SizedBox(height: 20),
            _buildHomeButton(
              context, 
              "Accept Food", 
              Icons.handshake, 
              const AvailableFoodScreen(), 
              isGreen: false
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context, String label, IconData icon, Widget target, {required bool isGreen}) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isGreen ? const Color(0xFF1B5E20) : const Color(0xFFFFC107),
          foregroundColor: isGreen ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}