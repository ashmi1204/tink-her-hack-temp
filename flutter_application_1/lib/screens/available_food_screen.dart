import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableFoodScreen extends StatelessWidget {
  const AvailableFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Food Near You")),
      body: StreamBuilder(
        // Connecting to your food-collector-6a344 database
        stream: FirebaseFirestore.instance.collection('donations').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.green),
                  title: Text(doc['foodItem']),
                  subtitle: Text("Quantity: ${doc['quantity']}"),
                  trailing: TextButton(
                    onPressed: () { /* Add 'Claim' logic here */ },
                    child: const Text("CLAIM"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}