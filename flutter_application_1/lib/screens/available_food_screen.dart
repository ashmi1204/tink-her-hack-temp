import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableFoodScreen extends StatelessWidget {
  const AvailableFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Food Near You")),
      body: StreamBuilder(
        // Filter only 'available' items so claimed ones disappear
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('status', isEqualTo: 'available')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(doc['foodItem']),
                  subtitle: Text("Quantity: ${doc['quantity']}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC107), // Mango Yellow
                    ),
                    onPressed: () async {
                      // Update the status in Firestore
                      await FirebaseFirestore.instance
                          .collection('donations')
                          .doc(doc.id)
                          .update({'status': 'claimed'});

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Food Reserved Successfully!')),
                        );
                      }
                    },
                    child: const Text("CLAIM", style: TextStyle(color: Colors.black)),
                  ),
                ),
              );
            },
          );
        },
      ), // Fixed: Added closing parenthesis for StreamBuilder
    ); // Fixed: Added closing parenthesis for Scaffold
  } // Fixed: Added closing brace for build method
}