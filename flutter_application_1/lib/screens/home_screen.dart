

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'donor_form_screen.dart';
import 'available_food_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showDonationHistory(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.history_rounded,
                          color: Color(0xFF2E7D32), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "My Donation History",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B4020),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[100], thickness: 1.5),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('donations')
                      .where('donorId', isEqualTo: uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7F2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.volunteer_activism_outlined,
                                  size: 48, color: Colors.grey[400]),
                            ),
                            const SizedBox(height: 16),
                            Text("No donations yet!",
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600])),
                            const SizedBox(height: 8),
                            Text("Start sharing food with those in need.",
                                style: GoogleFonts.lato(
                                    fontSize: 13, color: Colors.grey[400])),
                          ],
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: docs.length,
                      itemBuilder: (_, i) {
                        final d = docs[i];
                        final isClaimed = (d['status'] ?? '') == 'claimed';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FBF7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isClaimed
                                  ? const Color(0xFFA5D6A7)
                                  : const Color(0xFFFFE082),
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: isClaimed
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFFFC107),
                              child: Icon(
                                isClaimed ? Icons.check_rounded : Icons.access_time_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            title: Text(d['foodName'] ?? 'Unnamed Food',
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: const Color(0xFF1B4020))),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 3),
                                Text("${d['quantity']} · ${d['foodType']}",
                                    style: GoogleFonts.lato(
                                        fontSize: 12, color: Colors.grey[500])),
                                Text("Deadline: ${d['deadline']}",
                                    style: GoogleFonts.lato(
                                        fontSize: 11, color: Colors.grey[400])),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isClaimed
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFFFFDE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isClaimed ? "Claimed ✓" : "Available",
                                style: GoogleFonts.lato(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isClaimed
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFF57F17),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final displayName = email.contains('@') ? email.split('@')[0] : 'there';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      body: Stack(
        children: [
          // ── Decorative background blobs ──
          Positioned(
            top: -40,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4CAF50).withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFC107).withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top Bar ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.eco_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text("ReServe",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B5E20),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          _iconBtn(
                            icon: Icons.history_rounded,
                            tooltip: "My Donations",
                            onTap: () => _showDonationHistory(context),
                          ),
                          const SizedBox(width: 8),
                          _iconBtn(
                            icon: Icons.logout_rounded,
                            tooltip: "Logout",
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AuthScreen()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // ── Greeting ──
                        Text(
                          "Hello, $displayName 👋",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B4020),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "What would you like to do today?",
                          style: GoogleFonts.lato(
                              fontSize: 14, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 28),

                        // ── Hero Stats Banner ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E7D32).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Together we can",
                                        style: GoogleFonts.lato(
                                            color: Colors.white70, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text("End Food Waste 🌱",
                                        style: GoogleFonts.playfairDisplay(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () => _showDonationHistory(context),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.white38, width: 1),
                                        ),
                                        child: Text("View my history →",
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text("🥗", style: TextStyle(fontSize: 56)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text("Quick Actions",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B4020),
                            )),
                        const SizedBox(height: 14),

                        // ── Action Cards ──
                        Row(
                          children: [
                            Expanded(
                              child: _ActionCard(
                                title: "Donate Food",
                                subtitle: "Share surplus\nwith others",
                                emoji: "🤲",
                                color: const Color(0xFF2E7D32),
                                lightColor: const Color(0xFFE8F5E9),
                                target: const DonorFormScreen(),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _ActionCard(
                                title: "Find Food",
                                subtitle: "Claim available\ndonations",
                                emoji: "🍱",
                                color: const Color(0xFFF57F17),
                                lightColor: const Color(0xFFFFF8E1),
                                target: const AvailableFoodScreen(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── How It Works section ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("How it works",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1B4020),
                                  )),
                              const SizedBox(height: 14),
                              _stepRow("1", "Post surplus food with details",
                                  const Color(0xFF4CAF50)),
                              _stepRow("2", "Someone nearby claims it",
                                  const Color(0xFFFFC107)),
                              _stepRow("3", "Pick up & reduce waste together",
                                  const Color(0xFF2E7D32)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
        ),
      ),
    );
  }

  Widget _stepRow(String step, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(step,
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

// ── Interactive Action Card ──
class _ActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final Color lightColor;
  final Widget target;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.lightColor,
    required this.target,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) async {
        await _ctrl.reverse();
        if (context.mounted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => widget.target));
        }
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background accent circle
              Positioned(
                right: -18,
                top: -18,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.lightColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.emoji,
                        style: const TextStyle(fontSize: 34)),
                    const Spacer(),
                    Text(
                      widget.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B4020),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.lato(
                          fontSize: 11,
                          color: Colors.grey[500],
                          height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("Go →",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}