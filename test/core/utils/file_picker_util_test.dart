import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:nutrabit_paciente/core/models/file_type.dart';
import '../../auxfiles/file_picker_aux.dart';
import 'dart:typed_data';

class MockFilePickerPlatform extends fp.FilePicker {
  final fp.FilePickerResult? mockResult;

  MockFilePickerPlatform(this.mockResult);

  @override
  Future<fp.FilePickerResult?> pickFiles({
    bool allowCompression = true,
    bool allowMultiple = false,
    List<String>? allowedExtensions,
    int compressionQuality = 100,
    String? dialogTitle,
    String? initialDirectory,
    bool lockParentWindow = false,
    dynamic Function(fp.FilePickerStatus)? onFileLoading,
    bool readSequential = false,
    fp.FileType type = fp.FileType.any,
    bool withData = false,
    bool withReadStream = false,
  }) async {
    return mockResult;
  }
}
void main() {
  test('pickSelectedFile returns SelectedFile on valid pick', () async {
    // Simular un archivo seleccionado con path NO nulo (para plataforma no web)
    final mockFile = fp.PlatformFile(
      name: 'test.txt',
      bytes: Uint8List.fromList([1, 2, 3]),
      size: 3,
      path: '/fake/path/test.txt', // <- importante, no null
    );

    final mockResult = fp.FilePickerResult([mockFile]);
    final mockPicker = MockFilePickerPlatform(mockResult);

    final result = await pickSelectedFile(
      FileType.EXERCISE_PLAN, 
      'Test Title', 
      pickerPlatform: mockPicker,
    );

    expect(result, isNotNull);
    expect(result!.name, 'test.txt');
    expect(result.title, 'Test Title');
    expect(result.file, isNotNull);
    expect(result.bytes, isNull); // porque en no web, bytes es null
  });

  test('pickSelectedFile returns null if no file selected', () async {
    final mockPicker = MockFilePickerPlatform(null);

    final result = await pickSelectedFile(
      FileType.EXERCISE_PLAN, 
      'Test Title', 
      pickerPlatform: mockPicker,
    );

    expect(result, isNull);
  });
}
