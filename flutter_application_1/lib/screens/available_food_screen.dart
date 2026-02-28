// 

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AvailableFoodScreen extends StatelessWidget {
  AvailableFoodScreen({super.key});

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Food")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getAvailableFood(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ListTile(
                  title: Text(doc['foodName']),
                  subtitle: Text(
                      "${doc['foodType']} • ${doc['quantity']} • ${doc['location']}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _firestoreService.markAsAccepted(doc.id);
                    },
                    child: const Text("Accept"),
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