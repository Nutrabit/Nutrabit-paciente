import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDC607A),
      body: Center(
        child: Image.asset(
          'img/aloha.png',
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}