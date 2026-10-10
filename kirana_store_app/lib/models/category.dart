import 'package:flutter/material.dart';

class Category {
  final String id;
  final String nameHindi;
  final String nameEnglish;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.nameHindi,
    required this.nameEnglish,
    required this.icon,
    this.color = const Color(0xFF0E8345),
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameHindi': nameHindi,
      'nameEnglish': nameEnglish,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.value,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      nameHindi: json['nameHindi'] as String,
      nameEnglish: json['nameEnglish'] as String,
      icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue'] as int? ?? 0xFF0E8345),
    );
  }
}
