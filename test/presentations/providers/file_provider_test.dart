import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nutrabit_paciente/core/models/file_type.dart';
import 'package:url_launcher_platform_interface/link.dart';
import '../../auxfiles/file_provider_aux.dart';
import '../../auxfiles/file_picker_aux.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'file_provider_test.mocks.dart';

// --- Mocks para Firebase y URL Launcher ---
@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
  FileNotifier,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FileNotifier', () {
      late FileNotifier notifier;
      late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      notifier = FileNotifier(firestore: mockFirestore);

    });

    test('addFile adds a file to the state', () {
      final file = SelectedFile(
        name: 'plan.pdf',
        title: 'Plan de ejercicio',
        type: FileType.EXERCISE_PLAN,
        bytes: Uint8List(0),
      );
      notifier.addFile(file);
      expect(notifier.state.files, contains(file));
    });

    test('removeFile removes a file from the state', () {
      final file1 = SelectedFile(
        name: 'file1.pdf',
        title: 'Archivo 1',
        type: FileType.MEAL_PLAN, // o el tipo que quieras
        bytes: Uint8List(0),
      );

      final file2 = SelectedFile(
        name: 'file2.pdf',
        title: 'Archivo 2',
        type: FileType.EXERCISE_PLAN,
        bytes: Uint8List(0),
      );

      notifier.addFile(file1);
      notifier.addFile(file2);
      notifier.removeFile(file1);

      expect(notifier.state.files, [file2]);
    });
    test('setDownloading updates downloading map', () {
      notifier.setDownloading('file123', true);
      expect(notifier.state.downloading['file123'], true);
    });

    test('setDownloaded updates downloaded map', () {
      notifier.setDownloaded('file456', true);
      expect(notifier.state.downloaded['file456'], true);
    });

    test('fetchAllFilesOfType updates filesByType', () async {
      final firestore = MockFirebaseFirestore();
      final collection = MockCollectionReference<Map<String, dynamic>>();
      final query1 = MockQuery<Map<String, dynamic>>();
      final query2 = MockQuery<Map<String, dynamic>>();
      final query3 = MockQuery<Map<String, dynamic>>();
      final snapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final doc = MockQueryDocumentSnapshot<Map<String, dynamic>>();

      when(firestore.collection('files')).thenReturn(collection);
      when(collection.where('userId', isEqualTo: 'user123')).thenReturn(query1);
      when(
        query1.where('type', isEqualTo: FileType.EXERCISE_PLAN.name),
      ).thenReturn(query2);
      when(query2.orderBy('date', descending: true)).thenReturn(query3);
      when(query3.get()).thenAnswer((_) async => snapshot);

      when(snapshot.docs).thenReturn([doc]);
      when(doc.id).thenReturn('doc1');
      when(doc.data()).thenReturn({
        'title': 'Plan de Ejercicio',
        'type': 'EXERCISE_PLAN',
        'url': 'https://example.com/plan.pdf',
        'date': Timestamp.fromDate(DateTime.now()),
        'userId': 'user123',
      });

      final notifierWithMock = FileNotifier(firestore: firestore);
      await notifierWithMock.fetchAllFilesOfType(
        'user123',
        FileType.EXERCISE_PLAN,
      );

      final result = notifierWithMock.state.filesByType[FileType.EXERCISE_PLAN];
      expect(result, isNotNull);
      expect(result!.first.title, equals('Plan de Ejercicio'));
    });
  });

  group('downloadFile', () {
    setUp(() {
      UrlLauncherPlatform.instance = _MockUrlLauncher();
    });

    test('returns true when URL can be launched', () async {
      final mockLauncher = UrlLauncherPlatform.instance as _MockUrlLauncher;
      mockLauncher.setCanLaunch(true);
      final result = await downloadFile('https://example.com/file.pdf');
      expect(result, true);
    });

    test('returns false when launch fails', () async {
      final mockLauncher = UrlLauncherPlatform.instance as _MockUrlLauncher;
      mockLauncher.setCanLaunch(false);
      final result = await downloadFile('https://example.com/file.pdf');
      expect(result, false);
    });
  });
}

// --- Mock personalizado para URL Launcher ---
class _MockUrlLauncher extends UrlLauncherPlatform {
  bool _canLaunch = true;

  void setCanLaunch(bool value) => _canLaunch = value;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    if (_canLaunch) return true;
    throw Exception('Cannot launch');
  }

  @override
  Future<bool> canLaunch(String url) async => _canLaunch;

  @override
  LinkDelegate? get linkDelegate => throw UnimplementedError();
}
