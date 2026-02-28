import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'donor_form_screen.dart';
import 'available_food_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // lib/screens/home_screen.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Creative Logo & Title Section
            const Icon(Icons.eco_rounded, size: 80, color: Color(0xFF1B5E20)),
            const Text(
              "ReServe",
              style: TextStyle(
                fontFamily: 'Grifter', // Custom bold font
                fontSize: 48,
                color: Color(0xFF1B5E20),
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              "Reserve the surplus, Feed the future",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 50),
            // Side-by-side horizontal navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavBox(context, "DONATE", Icons.volunteer_activism, const DonorFormScreen()),
                const SizedBox(width: 20),
                _buildNavBox(context, "ACCEPT", Icons.handshake, const AvailableFoodScreen()),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildNavBox(BuildContext context, String label, IconData icon, Widget target) {
    return SizedBox(
      width: 140, // Constrained width
      height: 180, // Larger height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF1B5E20),
          foregroundColor: const Color(0xFFFFC107),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 15),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}