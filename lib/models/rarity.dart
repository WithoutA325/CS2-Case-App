import 'package:flutter/material.dart';

class Rarity {
  const Rarity({required this.id, required this.name, required this.color});

  final String id;
  final String name;
  final Color color;

  factory Rarity.fromJson(Map<String, dynamic>? json) {
    return Rarity(
      id: json?['id']?.toString() ?? '',
      name: json?['name']?.toString() ?? 'Unknown',
      color: _parseColor(json?['color']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color':
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
    };
  }

  static Color _parseColor(String? value) {
    if (value == null || value.isEmpty) {
      return const Color(0xFF9CA3AF);
    }

    final parsed = int.tryParse(value.replaceFirst('#', ''), radix: 16);
    if (parsed == null) {
      return const Color(0xFF9CA3AF);
    }

    return Color(0xFF000000 | parsed);
  }
}
