import 'package:flutter/material.dart';

class AppColors {
  // Couleurs définies
  static const Color red = Color(0xFFE30613);
  static const Color orange = Color(0xFFF39200);
  static const Color blue = Color(0xFF312783);
  static const Color blanc = Color(0xFFFFFFFF);
  static const Color noir = Color(0x000000000);

  // Dégradé combinant les trois couleurs
  static const LinearGradient gradient = LinearGradient(
    colors: [red, orange, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
