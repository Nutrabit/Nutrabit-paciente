import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:nutrabit_paciente/core/utils/decorations.dart';

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

int calculateAge(DateTime birthday) {
  final now = DateTime.now();
  int age = now.year - birthday.year;
  if (now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)) {
    age--;
  }
  return age;
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

String generateRandomPassword({int length = 6}) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();
  return List.generate(
    length,
    (index) => chars[rand.nextInt(chars.length)],
  ).join();
}


Future<void> showGenericPopupBack({
  required BuildContext context,
  required String message,
  required String id,
  required void Function(BuildContext context, String id) onNavigate,
}) async {
  final style = getDefaultPopupStyle();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: style.decoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              style.icon,
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: style.messageTextStyle,
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onNavigate(context, id);
                  },
                  style: style.buttonStyle,
                  child: Text(
                    'VOLVER',
                    style: style.buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



