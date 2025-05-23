import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart' as fp;
import 'package:nutrabit_paciente/core/models/file_type.dart';
import 'package:meta/meta.dart';

class SelectedFile {
  final Uint8List? bytes; 
  final File? file;       
  final String name;
  final String title;
  final FileType type;

  SelectedFile({
    this.bytes,
    this.file,
    required this.name,
    required this.title,
    required this.type,
  });
}

Future<SelectedFile?> pickSelectedFile(
  FileType type,
  String title, {
  @visibleForTesting
  dynamic pickerPlatform,
}) async {
  final picker = pickerPlatform ?? fp.FilePicker.platform;

  final result = await picker.pickFiles(
    withData: kIsWeb,
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.single;

    if (!kIsWeb && file.path == null) {
      return null;
    }

    return SelectedFile(
      bytes: kIsWeb ? file.bytes : null,
      file: !kIsWeb && file.path != null ? File(file.path!) : null,
      name: file.name,
      title: title,
      type: type,
    );
  } else {
    return null;
  }
}
