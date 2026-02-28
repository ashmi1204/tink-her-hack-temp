

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableFoodScreen extends StatelessWidget {
  const AvailableFoodScreen({super.key});

  void _showReviewDialog(BuildContext context, String foodName) {
    int selectedStars = 0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Text("⭐", style: TextStyle(fontSize: 28)),
                ),
                const SizedBox(height: 14),
                Text(
                  "Rate your experience",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B4020),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  foodName,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),

                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedStars = index + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            index < selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                            key: ValueKey('$index-$selectedStars'),
                            color: index < selectedStars
                                ? const Color(0xFFFFC107)
                                : Colors.grey[300],
                            size: 38,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedStars == 0
                      ? "Tap a star to rate"
                      : ["", "Poor 😕", "Fair 🙂", "Good 😊", "Very Good 😄", "Excellent! 🤩"][selectedStars],
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),

                // Review text field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E5DC), width: 1.2),
                  ),
                  child: TextField(
                    controller: reviewController,
                    maxLines: 2,
                    style: GoogleFonts.lato(fontSize: 14, color: const Color(0xFF1B4020)),
                    decoration: InputDecoration(
                      hintText: "Write a short review (optional)...",
                      hintStyle: GoogleFonts.lato(fontSize: 13, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: const BorderSide(color: Color(0xFFE0E5DC), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Skip",
                            style: GoogleFonts.lato(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // TODO: Save to Firestore
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(children: [
                              const Icon(Icons.favorite_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text("Thanks for your feedback!",
                                  style: GoogleFonts.lato()),
                            ]),
                            backgroundColor: const Color(0xFF2E7D32),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ));
                        },
                        child: Text("Submit",
                            style: GoogleFonts.lato(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F2),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: Color(0xFF2E7D32)),
          ),
        ),
        title: Text(
          "Available Food",
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B4020),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco_rounded, color: Color(0xFF2E7D32), size: 16),
                const SizedBox(width: 4),
                Text("Fresh",
                    style: GoogleFonts.lato(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('status', isEqualTo: 'available')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Text("🍽️", style: TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 20),
                  Text("Nothing here yet",
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B4020))),
                  const SizedBox(height: 8),
                  Text("Check back soon for available donations",
                      style: GoogleFonts.lato(
                          fontSize: 13, color: Colors.grey[500])),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              final foodName = doc['foodName'] ?? 'Unnamed Food';

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card header strip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F7F0),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                            child: const Text("🥘",
                                style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              foodName,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B4020),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("Available",
                                style: GoogleFonts.lato(
                                  color: const Color(0xFF2E7D32),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                        ],
                      ),
                    ),

                    // Card body
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _infoChip(
                                  Icons.restaurant_rounded,
                                  doc['foodType'] ?? '-',
                                  const Color(0xFFF0F7F0),
                                  const Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _infoChip(
                                  Icons.inventory_2_rounded,
                                  doc['quantity'] ?? '-',
                                  const Color(0xFFFFF8E1),
                                  const Color(0xFFF57F17),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _detailRow(
                            Icons.location_on_rounded,
                            doc['pickupDetails'] ?? '-',
                            const Color(0xFF2E7D32),
                          ),
                          const SizedBox(height: 8),
                          _detailRow(
                            Icons.timer_rounded,
                            "Pickup by: ${doc['deadline'] ?? '-'}",
                            const Color(0xFFE53935),
                            bold: true,
                          ),
                          const SizedBox(height: 16),

                          // Claim button
                          SizedBox(
                            width: double.infinity,
                            child: _ClaimButton(
                              docId: doc.id,
                              foodName: foodName,
                              onClaimed: (capturedContext) {
                                _showReviewDialog(capturedContext, foodName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B4020))),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text, Color iconColor,
      {bool bold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: bold ? iconColor : Colors.grey[600],
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Claim Button StatefulWidget ──
class _ClaimButton extends StatefulWidget {
  final String docId;
  final String foodName;
  final void Function(BuildContext context) onClaimed;

  const _ClaimButton({
    required this.docId,
    required this.foodName,
    required this.onClaimed,
  });

  @override
  State<_ClaimButton> createState() => _ClaimButtonState();
}

class _ClaimButtonState extends State<_ClaimButton> {
  bool _isClaiming = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: _isClaiming
          ? null
          : () async {
              setState(() => _isClaiming = true);

              final messenger = ScaffoldMessenger.of(context);
              final capturedContext = context;

              try {
                await FirebaseFirestore.instance
                    .collection('donations')
                    .doc(widget.docId)
                    .update({'status': 'claimed'});

                messenger.showSnackBar(SnackBar(
                  content: Row(children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text("Food claimed successfully!",
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
                  ]),
                  backgroundColor: const Color(0xFF2E7D32),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  duration: const Duration(seconds: 2),
                ));

                await Future.delayed(const Duration(milliseconds: 400));

                if (mounted) widget.onClaimed(capturedContext);
              } catch (e) {
                debugPrint("Claim error: $e");
                if (mounted) setState(() => _isClaiming = false);
              }
            },
      child: _isClaiming
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.handshake_rounded, size: 18),
                const SizedBox(width: 8),
                Text("Claim This Food",
                    style: GoogleFonts.lato(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
    );
  }
}