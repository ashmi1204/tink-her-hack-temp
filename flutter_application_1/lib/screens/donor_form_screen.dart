


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class DonorFormScreen extends StatefulWidget {
  const DonorFormScreen({super.key});
  @override
  State<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _qtyController = TextEditingController();
  final _pickupController = TextEditingController();
  final _deadlineController = TextEditingController();
  bool _isUploading = false;

  // Food type selection
  String _selectedType = '';
  final List<Map<String, String>> _foodTypes = [
    {'label': '🥦 Veg', 'value': 'Vegetarian'},
    {'label': '🍗 Non-Veg', 'value': 'Non-Vegetarian'},
    {'label': '🥛 Dairy', 'value': 'Dairy'},
    {'label': '🍞 Bakery', 'value': 'Bakery'},
  ];

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameController.dispose();
    _typeController.dispose();
    _qtyController.dispose();
    _pickupController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _uploadFood() async {
    if (_nameController.text.trim().isEmpty ||
        _qtyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text("Please fill Food Name and Quantity",
              style: GoogleFonts.lato()),
        ]),
        backgroundColor: const Color(0xFFF57F17),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      return;
    }

    setState(() => _isUploading = true);

    try {
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final type = _selectedType.isNotEmpty
          ? _selectedType
          : _typeController.text.trim();

      await FirebaseFirestore.instance.collection('donations').add({
        'donorId': FirebaseAuth.instance.currentUser!.uid,
        'foodName': _nameController.text.trim(),
        'foodType': type,
        'quantity': _qtyController.text.trim(),
        'pickupDetails': _pickupController.text.trim(),
        'deadline': _deadlineController.text.trim(),
        'lat': pos.latitude,
        'lng': pos.longitude,
        'status': 'available',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _typeController.clear();
      _qtyController.clear();
      _pickupController.clear();
      _deadlineController.clear();
      setState(() => _selectedType = '');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text("Food posted successfully! 🎉",
                style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
          ]),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ));
      }
    } on LocationServiceDisabledException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please enable location services.",
              style: GoogleFonts.lato()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something went wrong. Try again.",
              style: GoogleFonts.lato()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
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
          "Donate Food",
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B4020),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero header card ──
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
                        color: const Color(0xFF2E7D32).withOpacity(0.25),
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
                            Text("Share with care 🤲",
                                style: GoogleFonts.lato(
                                    color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 6),
                            Text("What are you\nsharing today?",
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                )),
                          ],
                        ),
                      ),
                      const Text("🥗", style: TextStyle(fontSize: 52)),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Form card ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel("Food Details"),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _nameController,
                        label: "Food Name *",
                        icon: Icons.fastfood_rounded,
                        hint: "e.g. Biryani, Dal Rice...",
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        controller: _qtyController,
                        label: "Quantity *",
                        icon: Icons.inventory_2_rounded,
                        hint: "e.g. 5 plates, 2 kg...",
                      ),

                      const SizedBox(height: 22),
                      _sectionLabel("Food Type"),
                      const SizedBox(height: 12),

                      // ── Quick type selector chips ──
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _foodTypes.map((type) {
                          final selected = _selectedType == type['value'];
                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedType = selected ? '' : type['value']!;
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFF5F7F2),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE0E5DC),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                type['label']!,
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF1B4020),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        controller: _typeController,
                        label: "Or type custom food type",
                        icon: Icons.edit_rounded,
                        hint: "e.g. Vegan, Gluten-free...",
                      ),

                      const SizedBox(height: 22),
                      _sectionLabel("Pickup Info"),
                      const SizedBox(height: 12),
                      _buildField(
                        controller: _pickupController,
                        label: "Pickup Location / Details",
                        icon: Icons.location_on_rounded,
                        hint: "e.g. Near gate, 3rd floor...",
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        controller: _deadlineController,
                        label: "Pickup Deadline",
                        icon: Icons.timer_rounded,
                        hint: "e.g. Today 9 PM, Tomorrow noon...",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Submit button ──
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadFood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.volunteer_activism_rounded,
                                  size: 20),
                              const SizedBox(width: 10),
                              Text("Post Donation",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3)),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // Note
                Center(
                  child: Text(
                    "📍 Your location will be saved with this post",
                    style: GoogleFonts.lato(
                        fontSize: 12, color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.playfairDisplay(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B4020),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String hint = '',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E5DC), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.lato(fontSize: 14, color: const Color(0xFF1B4020)),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.lato(color: Colors.grey[400], fontSize: 13),
          hintStyle: GoogleFonts.lato(color: Colors.grey[350], fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 19),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
}