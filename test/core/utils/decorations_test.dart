import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';


void main() {
  test('textFieldDecoration genera InputDecoration con label y bordes correctos', () {
    final label = 'Correo';
    final decoration = textFieldDecoration(label);

    expect(decoration.labelText, label);
    expect(decoration.border, isA<OutlineInputBorder>());
    final border = decoration.border as OutlineInputBorder;
    expect(border.borderRadius, BorderRadius.circular(8));
    expect(decoration.contentPadding, const EdgeInsets.symmetric(horizontal: 12, vertical: 8));
  });

  test('mainButtonDecoration genera ElevatedButton con colores y forma correctos', () {
    final style = mainButtonDecoration();

    final backgroundColor = style.backgroundColor?.resolve({}) ?? Colors.transparent;
    final foregroundColor = style.foregroundColor?.resolve({}) ?? Colors.transparent;

    expect(backgroundColor, const Color(0xFFDC607A));
    expect(foregroundColor, const Color(0xFFFDEEDB));

    final shape = style.shape?.resolve({}) as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(12));

    final padding = style.padding?.resolve({}) as EdgeInsets;
    expect(padding, const EdgeInsets.symmetric(horizontal: 32, vertical: 12));
  });
}
