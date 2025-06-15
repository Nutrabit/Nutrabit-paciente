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
    suffixText: suffix, 
  );
  }

  

class PopupStyle {
  final BoxDecoration decoration;
  final TextStyle messageTextStyle;
  final ButtonStyle buttonStyle;
  final TextStyle buttonTextStyle;
  final Widget icon;

  const PopupStyle({
    required this.decoration,
    required this.messageTextStyle,
    required this.buttonStyle,
    required this.buttonTextStyle,
    required this.icon,
  });
}


PopupStyle getDefaultPopupStyle() {
  return PopupStyle(
    decoration: BoxDecoration(
      color: const Color(0xFFFEECDa),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    messageTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15,
      color: Color(0xFF2F2F2F),
      letterSpacing: 0.3,
      height: 1.4,
    ),
    buttonStyle: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Color(0xFFDC607A)),
      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: const BorderSide(color: Colors.black),
        ),
      ),
      elevation: const MaterialStatePropertyAll(2),
    ),
    buttonTextStyle: const TextStyle(
      fontSize: 14,
      color: Color(0xFFFDEEDB),
      fontWeight: FontWeight.bold,
    ),
    icon: const Icon(Icons.info_outline, color: Colors.black87, size: 36),
  );
}



class AlertDialogStyle {
  final ShapeBorder? shape;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;
  final Color? backgroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? contentPadding;

  const AlertDialogStyle({
    this.shape,
    this.titleTextStyle,
    this.contentTextStyle,
    this.buttonStyle,
    this.buttonTextStyle,
    this.backgroundColor,
    this.elevation,
    this.contentPadding,
  });
}

const AlertDialogStyle defaultAlertDialogStyle = AlertDialogStyle(
  backgroundColor: Color(0xFFFEECDa),
  elevation: 10,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    side: BorderSide(color: Colors.black, width: 2),
  ),
  titleTextStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Color(0xFF2F2F2F),
    letterSpacing: 0.3,
    height: 1.4,
  ),
  contentTextStyle: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Color(0xFF2F2F2F),
  ),
  buttonStyle: ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Color(0xFFDC607A)),
    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12)),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(color: Colors.black),
      ),
    ),
    elevation: MaterialStatePropertyAll(2),
  ),
  buttonTextStyle: TextStyle(
    fontSize: 14,
    color: Color(0xFFFDEEDB),
    fontWeight: FontWeight.bold,
  ),
  contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 24),
);
