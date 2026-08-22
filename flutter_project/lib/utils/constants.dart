import 'package:flutter/material.dart';

const List<String> categoriesList = [
  'Vitamins',
  'Antibiotics',
  'Pain Relief',
  'Digestive',
  'Pressure',
  'Other',
];

const List<String> typesList = [
  'Tablet',
  'Capsule',
  'Syrup',
  'Injection',
];

const List<String> frequenciesList = [
  'Once daily',
  'Twice daily',
  'Three times daily',
  'Every 8 hours',
  'As needed',
];

const Color primaryColor = Color(0xffC50050);
const Color primaryDarkColor = Color(0xFF1565C0);
const Color secondaryColor = Color(0xFF7C4DFF);
const Color tertiaryColor = Color(0xFF00BCD4);
const Color backgroundColor = Color(0xFFF5F7FB);
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF2D3748);
const Color subTextColor = Color(0xFF718096);

class CategoryStyle {
  final Color color;
  final IconData icon;
  const CategoryStyle(this.color, this.icon);
}

const Map<String, CategoryStyle> categoryStyle = {
  'Vitamins': CategoryStyle(Color(0xFFE3DAFF), Icons.spa),
  'Antibiotics': CategoryStyle(Color(0xFFCDEFFF), Icons.medication_liquid),
  'Pain Relief': CategoryStyle(Color(0xFFFFD6E0), Icons.healing),
  'Digestive': CategoryStyle(Color(0xFFDCF5E3), Icons.restaurant),
  'Pressure': CategoryStyle(Color(0xFFE6E6E6), Icons.favorite),
  'Other': CategoryStyle(Color(0xFFFFE0E9), Icons.more_horiz),
};

CategoryStyle styleForCategory(String category) =>
    categoryStyle[category] ?? const CategoryStyle(Color(0xFFF0F0F0), Icons.medication);
