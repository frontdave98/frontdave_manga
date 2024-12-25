import 'package:flutter/material.dart';

class DesignSystem {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 32.0;
  static final skeletonGradient = (Color color_1, Color color_2) =>
      LinearGradient(colors: [color_1, color_2]);
}

class TextStyles {
  static const TextStyle heading =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle body =
      TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const TextStyle appBar =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
}
