import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart' as fp;
import '../models/file_type.dart';

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

Future<SelectedFile?> pickSelectedFile(FileType type, String title) async {
  final result = await fp.FilePicker.platform.pickFiles(
    withData: kIsWeb, 
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.single;

    if (!kIsWeb && file.path == null) {
      print("Error: El archivo no tiene una ruta válida.");
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
    print("No se seleccionó ningún archivo.");
    return null;
  }
}