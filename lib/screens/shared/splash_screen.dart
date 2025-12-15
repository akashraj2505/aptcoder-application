import 'package:aptcoder_application/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final user = _auth.currentUser;

    if (user == null) {
      // ❌ Not logged in
      _go('/roleSelection');
      return;
    }

    // ✅ Logged in → check role
    final userData = await _userService.getUser(user.uid);

    if (userData == null) {
      _go('/roleSelection');
      return;
    }

    final role = userData['role'];

    if (role == 'admin') {
      _go('/adminDashboard');
    } else if (role == 'student') {
      _go('/studentDashboard');
    } else {
      _go('/roleSelection');
    }
  }

  void _go(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
