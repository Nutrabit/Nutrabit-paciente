import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrabit_paciente/core/models/file_model.dart';  
import 'package:nutrabit_paciente/core/models/file_type.dart';   

void main() {
  group('FileModel', () {
    final now = DateTime.now();

    test('toJson genera el mapa correctamente', () {
      final file = FileModel(
        id: 'abc123',
        title: 'Plan de ejercicio',
        type: FileType.EXERCISE_PLAN,
        url: 'https://example.com/file.pdf',
        date: now,
        userId: 'user123',
      );

      final json = file.toJson();

      expect(json['title'], 'Plan de ejercicio');
      expect(json['type'], 'EXERCISE_PLAN');
      expect(json['url'], 'https://example.com/file.pdf');
      expect(json['date'], isA<Timestamp>());
      expect(json['userId'], 'user123');
    });

    test('fromJson crea un FileModel correctamente', () {
      final timestamp = Timestamp.fromDate(now);

      final json = {
        'title': 'Plan de dieta',
        'type': 'MEAL_PLAN',
        'url': 'https://example.com/diet.pdf',
        'date': timestamp,
        'userId': 'user456',
      };

      final file = FileModel.fromJson(json, id: 'file789');

      expect(file.id, 'file789');
      expect(file.title, 'Plan de dieta');
      expect(file.type, FileType.MEAL_PLAN);
      expect(file.url, 'https://example.com/diet.pdf');
      expect(file.date, now);
      expect(file.userId, 'user456');
    });
  });
}