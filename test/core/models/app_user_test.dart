import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'app_user_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  group('AppUser', () {
    final now = DateTime.now();

    final sampleMap = {
      'dni': '12345678',
      'name': 'Juan',
      'lastname': 'Pérez',
      'email': 'juan@example.com',
      'birthday': Timestamp.fromDate(now),
      'height': 180,
      'weight': 75,
      'gender': 'M',
      'isActive': true,
      'profilePic': 'https://example.com/photo.jpg',
      'goal': 'Perder peso',
      'events': [
        {'type': 'login', 'timestamp': 'algo'},
      ],
      'appointments': [Timestamp.fromDate(now)],
      'createdAt': Timestamp.fromDate(now),
      'modifiedAt': Timestamp.fromDate(now),
      'deletedAt': null,
    };

    test('toMap() genera el mapa correctamente', () {
      final user = AppUser(
        id: 'uid123',
        dni: '12345678',
        name: 'Juan',
        lastname: 'Pérez',
        email: 'juan@example.com',
        birthday: now,
        height: 180,
        weight: 75,
        gender: 'M',
        isActive: true,
        profilePic: 'https://example.com/photo.jpg',
        goal: 'Perder peso',
        events: [
          {'type': 'login', 'timestamp': 'algo'}
        ],
        appointments: [Timestamp.fromDate(now)],
      );

      final map = user.toMap();

      expect(map['name'], 'Juan');
      expect(map['dni'], '12345678');
      expect(map['appointments'], isA<List<Timestamp>>());
      expect(map['createdAt'], isA<Timestamp>());
      expect(map['modifiedAt'], isA<Timestamp>());
    });

    test('copyWith() actualiza campos correctamente', () {
      final user = AppUser(
        id: 'uid123',
        dni: '12345678',
        name: 'Juan',
        lastname: 'Pérez',
        email: 'juan@example.com',
        birthday: now,
        height: 180,
        weight: 75,
        gender: 'M',
        isActive: true,
        profilePic: '',
        goal: '',
        events: [],
        appointments: [],
      );

      final updated = user.copyWith(name: 'Carlos', height: 190);

      expect(updated.name, 'Carlos');
      expect(updated.height, 190);
      expect(updated.id, 'uid123'); // campo no cambiado
    });

    test('merge() combina cambios correctamente', () {
      final user = AppUser(
        id: 'uid123',
        dni: '12345678',
        name: 'Juan',
        lastname: 'Pérez',
        email: 'juan@example.com',
        birthday: now,
        height: 180,
        weight: 75,
        gender: 'M',
        isActive: true,
        profilePic: '',
        goal: '',
        events: [],
        appointments: [],
      );

      final changes = {
        'name': 'Lucas',
        'height': 185,
        'deletedAt': now,
      };

      final merged = user.merge(changes);

      expect(merged.name, 'Lucas');
      expect(merged.height, 185);
      expect(merged.deletedAt, now);
    });
  });

  test('fromFirestore crea un AppUser correctamente', () {
  final mockSnapshot = MockDocumentSnapshot();

  final now = DateTime.now();
  final timestamp = Timestamp.fromDate(now);

  when(mockSnapshot.id).thenReturn('user123');
  when(mockSnapshot.data()).thenReturn({
    'dni': '12345678',
    'name': 'Lucía',
    'lastname': 'Gómez',
    'email': 'lucia@example.com',
    'birthday': timestamp,
    'height': 165,
    'weight': 60,
    'gender': 'F',
    'isActive': true,
    'profilePic': '',
    'goal': 'Mantener',
    'events': [],
    'appointments': [timestamp],
    'createdAt': timestamp,
    'modifiedAt': timestamp,
    'deletedAt': null,
  });

  final user = AppUser.fromFirestore(mockSnapshot);

  expect(user.id, 'user123');
  expect(user.name, 'Lucía');
  expect(user.birthday, now);
  expect(user.height, 165);
  expect(user.isActive, true);
  });
}