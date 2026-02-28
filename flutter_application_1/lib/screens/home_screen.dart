import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'donor_form_screen.dart';
import 'available_food_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Grifter Headline
            const Text(
              "RESERVE",
              style: TextStyle(
                fontFamily: 'Grifter', // Needs registration in pubspec.yaml
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1B5E20),
                letterSpacing: 2,
              ),
            ),
            Text(
              "Reserve the surplus, Feed the future",
              style: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
            ),
            const Spacer(),
            
            // Side-by-Side Horizontal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCompactNav(context, "DONATE", Icons.volunteer_activism, const DonorFormScreen()),
                const SizedBox(width: 20),
                _buildCompactNav(context, "ACCEPT", Icons.handshake, const AvailableFoodScreen()),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactNav(BuildContext context, String label, IconData icon, Widget target) {
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