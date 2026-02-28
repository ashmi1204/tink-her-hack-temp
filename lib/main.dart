import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file is in your lib folder

void main() async {
  // 1. Ensure Flutter is fully initialized before starting Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase using your specific credentials
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FoodConnectorApp());
}

class FoodConnectorApp extends StatelessWidget {
  const FoodConnectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Waste Connector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // We will create the DonorHomeScreen next
      home: const DonorHomeScreen(), 
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