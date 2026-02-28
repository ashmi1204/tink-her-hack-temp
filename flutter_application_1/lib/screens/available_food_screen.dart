// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AvailableFoodScreen extends StatelessWidget {
//   const AvailableFoodScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Available Food Near You"),
//       ),
//       body: StreamBuilder(
//         // Connecting to your food-collector-6a344 database
//         stream: FirebaseFirestore.instance
//             .collection('donations')
//             .where('status', isEqualTo: 'available')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             padding: const EdgeInsets.all(12),
//             itemBuilder: (context, index) {
//               var doc = snapshot.data!.docs[index];
//               return Card(
//                 color: const Color(0xFF1B5E20), // Forest Green
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: ListTile(
//                   title: Text(
//                     doc['foodItem'],
//                     style: const TextStyle(
//                       color: Color(0xFFFFC107), // Mango Yellow
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Inter',
//                     ),
//                   ),
//                   subtitle: Text(
//                     "Quantity: ${doc['quantity']}",
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontFamily: 'Inter',
//                     ),
//                   ),
//                   trailing: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFFC107), // Mango Yellow
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onPressed: () async {
//                       try {
//                         // Update the status in Firestore
//                         await FirebaseFirestore.instance
//                             .collection('donations')
//                             .doc(doc.id)
//                             .update({'status': 'claimed'});

//                         if (context.mounted) {
//                           // Success Pop-up
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Successfully claimed the food!',
//                                 style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               backgroundColor: Color(0xFFFFC107),
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         }
//                       } catch (e) {
//                         debugPrint("Claim Error: $e");
//                       }
//                     },
//                     child: const Text(
//                       "CLAIM",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableFoodScreen extends StatelessWidget {
  const AvailableFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Food")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('status', isEqualTo: 'available')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.all(15),
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return Card(
                color: const Color(0xFF1B5E20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc['foodName'] ?? 'Unnamed Food', 
                        style: const TextStyle(color: Color(0xFFFFC107), fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text("Type: ${doc['foodType']}", style: const TextStyle(color: Colors.white)),
                      Text("Quantity: ${doc['quantity']}", style: const TextStyle(color: Colors.white)),
                      Text("Location: ${doc['pickupDetails']}", style: const TextStyle(color: Colors.white)),
                      Text("Deadline: ${doc['deadline']}", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      // "Hug Content" Claim Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: Colors.black,
                            minimumSize: Size.zero, // Allows hugging
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          // lib/screens/available_food_screen.dart
onPressed: () async {
  await FirebaseFirestore.instance
      .collection('donations')
      .doc(doc.id)
      .update({'status': 'claimed'});

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully claimed the food!'),
        backgroundColor: Color(0xFFFFC107),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
},
                          child: const Text("CLAIM"),
                        ),
                      ),
                    ],
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