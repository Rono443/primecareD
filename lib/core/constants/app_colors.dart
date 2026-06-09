import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF2D62ED);
  static const Color secondary = Color(0xFF191D21);
  static const Color accent = Color(0xFF5ED3FF);
  
  // Neutral Tones
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFFF4B4B);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFAEB5BC);
  
  // Status Colors (Vibrant but Uniform)
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF2994A);
  static const Color info = Color(0xFF2D62ED);
  static const Color pending = Color(0xFF9B51E0); // Purple for pending/received

  // Premium Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2D62ED), Color(0xFF6B93FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF27AE60), Color(0xFFA8E063)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pendingGradient = LinearGradient(
    colors: [Color(0xFF9B51E0), Color(0xFFE0C3FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Surface Glow Effects
  static List<BoxShadow> get softGlow => [
    BoxShadow(
      color: primary.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get successGlow => [
    BoxShadow(
      color: success.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
