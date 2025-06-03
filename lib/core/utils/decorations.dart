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

InputDecoration inputDecoration(String label, {String? suffix}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFDC607A), width: 2.0),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFDC607A), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    suffixText: suffix, // Aquí se añade el sufijo opcional
  );
  }