import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({super.key});

  @override
  State<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard> {
  final _futureDateController = TextEditingController();

  // Function to record future donation intent
  Future<void> _recordFutureIntent() async {
    if (_futureDateController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('future_donations').add({
      'donorId': FirebaseAuth.instance.currentUser!.uid,
      'plannedDate': _futureDateController.text,
      'status': 'planned',
      'timestamp': FieldValue.serverTimestamp(),
    });

    _futureDateController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Future intent recorded! Viewers can now see this.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Dashboard", style: TextStyle(fontFamily: 'Grifter')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(), // Logs user out
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Future Planning
            _buildSectionHeader("Plan Ahead"),
            const Text("Planning to donate food in the upcoming month?", 
                style: TextStyle(fontFamily: 'Inter', fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _futureDateController,
                    decoration: const InputDecoration(
                      hintText: "Enter approx. date (e.g. March 15)",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _recordFutureIntent,
                  child: const Text("Notify"),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // Section 2: Past Donations
            _buildSectionHeader("Your Past Impact"),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('donations')
                  .where('donorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                if (snapshot.data!.docs.isEmpty) return const Text("No donations yet. Start today!");

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return Card(
                      color: const Color(0xFF1B5E20),
                      child: ListTile(
                        title: Text(doc['foodItem'], style: const TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold)),
                        subtitle: Text("Status: ${doc['status']}", style: const TextStyle(color: Colors.white70)),
                        trailing: const Icon(Icons.check_circle, color: Colors.white),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontFamily: 'Grifter', fontSize: 24, color: Color(0xFF1B5E20))),
    );
  }
}