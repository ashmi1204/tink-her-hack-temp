import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Firebase with your food-collector-6a344 options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Run the themed app class
  runApp(const FoodConnectorApp());
}

class FoodConnectorApp extends StatelessWidget {
  const FoodConnectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserve',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Defining your Dark Green and Mango Yellow palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Dark Green
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFFFFC107), // Mango Yellow
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Color(0xFFFFC107), // Yellow text on Green bar
          centerTitle: true,
        ),
      ),
      // Pointing to your redesigned Home Screen
      home: const HomeScreen(),
    );
  }
}
// A temporary placeholder for your first screen
class DonorHomeScreen extends StatelessWidget {
  const DonorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Waste Connector")),
      body: const Center(child: Text("Firebase Connected. Ready to build the Donor Form!")),
    );
  }
}