import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  // Part of lib/screens/auth_screen.dart
Future<void> _submit() async {
  if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) return;
  
  setState(() => _isLoading = true);
  try {
    if (_isLogin) {
      // Login existing user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(), 
        password: _passCtrl.text.trim(),
      );
    } else {
      // Register new user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(), 
        password: _passCtrl.text.trim(),
      );
    }
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Authentication failed")),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("RESERVE", style: TextStyle(fontFamily: 'Grifter', fontSize: 40, color: Color(0xFF1B5E20))),
            const SizedBox(height: 30),
            _buildAuthField("Email", _emailCtrl, false),
            _buildAuthField("Password", _passCtrl, true),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? "Login" : "Register"),
                ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? "Create an account" : "I already have an account", 
                style: GoogleFonts.inter(color: const Color(0xFF1B5E20))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthField(String label, TextEditingController ctrl, bool isPass) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: ctrl,
        obscureText: isPass,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Color(0xFFFFC107)), border: InputBorder.none),
      ),
    );
  }
}