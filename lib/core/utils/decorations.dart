import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );
}

ButtonStyle mainButtonDecoration() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFDC607A),
    foregroundColor: Color(0xFFFDEEDB),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}

const titleStyle = const TextStyle(
  fontFamily: 'Inter',
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

const textStyle = const TextStyle(fontFamily: 'Inter', fontSize: 18);
