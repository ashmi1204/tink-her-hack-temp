import 'package:flutter/material.dart';
import 'donor_form_screen.dart';
import 'available_food_screen.dart'; // We will create this next

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Connector")),
      // The Menu Bar (Drawer)
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.fastfood),
              title: const Text("Available Foods"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AvailableFoodScreen())),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(context, "Donate Food", Icons.volunteer_activism, const DonorFormScreen()),
            const SizedBox(height: 20),
            _buildOptionCard(context, "Accept Food", Icons.handshake, const AvailableFoodScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, Widget target) {
    return SizedBox(
      width: 250,
      height: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 50), Text(title, style: const TextStyle(fontSize: 20))],
        ),
      ),
    );
  }
}