import 'package:flutter/material.dart';

class AppGradients {
  // Admin Gradient (used in Role Selection & Admin Signup)
  static const LinearGradient adminGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF42A5F5), // blue.shade400
      Color(0xFF1E88E5), // blue.shade600
    ],
  );

  // Student Gradient (optional, future use)
  static const LinearGradient studentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFAB47BC), // purple.shade400
      Color(0xFF8E24AA), // purple.shade600
    ],
  );
}
