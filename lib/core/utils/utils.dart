import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[áàäâã]'), 'a')
      .replaceAll(RegExp(r'[éèëê]'), 'e')
      .replaceAll(RegExp(r'[íìïî]'), 'i')
      .replaceAll(RegExp(r'[óòöôõ]'), 'o')
      .replaceAll(RegExp(r'[úùüû]'), 'u')
      .replaceAll('ñ', 'n');
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*"
    r"\.(com|net|org|edu|gov|mil|info|io|co)$",
    caseSensitive: false,
  );
  return emailRegex.hasMatch(email);
}

extension StringCasingExtension on String {
  
  String capitalize() {
    if (isEmpty) return "";
    return this[0].toUpperCase() + substring(1);
  }
}

 String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return dateFormat.format(date);
  }

Future<void> showCustomDialog({
  required BuildContext context,
  required String message,
  required String buttonText,
  required Color buttonColor,
  VoidCallback? onPressed,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            const Divider(),
          ],
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      );
    },
  );
}