import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';
import 'package:nutrabit_paciente/core/models/file_type.dart';
import 'package:nutrabit_paciente/core/utils/file_picker_util.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/file_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/files/download_screen.dart';

// Fake AuthNotifier para test (extiende AsyncNotifier)
class FakeAuthNotifier extends AsyncNotifier<AppUser?> implements AuthNotifier {
  @override
  FutureOr<AppUser?> build() {
    return AppUser(
      id: 'fake_id',
      dni: '12345678',
      name: 'Fake',
      lastname: 'User',
      email: 'fakeuser@example.com',
      birthday: DateTime(1990, 1, 1),
      height: 170,
      weight: 70,
      gender: 'M',
      isActive: true,
      profilePic: '',
      goal: 'Maintain weight',
      events: [],
      appointments: [],
    );
  }

  @override
  FirebaseFirestore get db => throw UnimplementedError();

  @override
  Future<bool> isPacienteByEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatPassword,
  }) {
    throw UnimplementedError();
  }
}

// Instancia fake
final fakeAuthNotifier = FakeAuthNotifier();

// Fake FileNotifier
class FakeFileNotifier extends StateNotifier<FileState>
    implements FileNotifier {
  FakeFileNotifier() : super(FileState());

  @override
  void setDownloading(String id, bool value) {}

  @override
  void setDownloaded(String id, bool value) {}

  @override
  void addFile(SelectedFile newFile) {}

  @override
  Future<void> fetchAllFilesOfType(String userId, FileType fileType) async {}

  @override
  void removeFile(SelectedFile fileToRemove) {}
}

// Provider fake para files
final fakeFileProvider = StateNotifierProvider<FileNotifier, FileState>(
  (ref) => FakeFileNotifier(),
);

void main() {
  testWidgets('Descargas - muestra AppBar y tiles vacíos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => fakeAuthNotifier),
          fileProvider.overrideWithProvider(fakeFileProvider),
        ],
        child: MaterialApp(
          home: const DownloadScreen(),
          routes: {
            '/login':
                (context) => const Scaffold(body: Center(child: Text('Login'))),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Descargas'), findsOneWidget);
    expect(
      find.byType(FileTypeExpansionTile),
      findsNWidgets(FileType.values.length),
    );
  });

  testWidgets('Descargas - muestra mensaje si no hay archivos', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => fakeAuthNotifier),
          fileProvider.overrideWithProvider(fakeFileProvider),
        ],
        child: MaterialApp(
          home: const DownloadScreen(),
          routes: {
            '/login':
                (context) => const Scaffold(body: Center(child: Text('Login'))),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    final firstTile = find.byType(ExpansionTile).first;
    await tester.tap(firstTile);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(
      find.text('Aún no has recibido archivos de este tipo'),
      findsWidgets,
    );
  });

}
