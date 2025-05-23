import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/file_model.dart';
import 'package:nutrabit_paciente/core/models/file_type.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'file_picker_aux.dart';

class FileState {
  final List<SelectedFile> files;
  final Map<FileType, List<FileModel>> filesByType;
  final Map<String, bool> downloading;
  final Map<String, bool> downloaded;

  FileState({
    this.files = const [],
    this.filesByType = const {},
    this.downloading = const {},
    this.downloaded = const {},
  });

  FileState copyWith({
    List<SelectedFile>? files,
    Map<FileType, List<FileModel>>? filesByType,
    Map<String, bool>? downloading,
    Map<String, bool>? downloaded,
  }) {
    return FileState(
      files: files ?? this.files,
      filesByType: filesByType ?? this.filesByType,
      downloading: downloading ?? this.downloading,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  factory FileState.initial() => FileState(
        files: [],
        filesByType: {},
        downloading: {},
        downloaded: {},
      );
}

class FileNotifier extends StateNotifier<FileState> {
  final FirebaseFirestore firestore;

  FileNotifier({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance,
        super(FileState.initial());

  void addFile(SelectedFile newFile) {
    final updatedList = [...state.files, newFile];
    state = state.copyWith(files: updatedList);
  }

  void removeFile(SelectedFile fileToRemove) {
    final updatedList = state.files.where((f) => f != fileToRemove).toList();
    state = state.copyWith(files: updatedList);
  }

  Future<void> fetchAllFilesOfType(String userId, FileType fileType) async {
    try {
      final snapshot = await firestore
          .collection('files')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: fileType.name)
          .orderBy('date', descending: true)
          .get();

      final files = snapshot.docs
          .map((doc) => FileModel.fromJson(doc.data(), id: doc.id))
          .toList();

      final updatedMap = Map<FileType, List<FileModel>>.from(state.filesByType);
      updatedMap[fileType] = files;

      state = state.copyWith(
        filesByType: updatedMap,
      );
    } catch (e) {
      print("Error al filtrar archivos por tipo: $e");
    }
  }

  void setDownloading(String fileId, bool value) {
    final updated = {...state.downloading, fileId: value};
    state = state.copyWith(downloading: updated);
  }

  void setDownloaded(String fileId, bool value) {
    final updated = {...state.downloaded, fileId: value};
    state = state.copyWith(downloaded: updated);
  }
}

final fileProvider = StateNotifierProvider<FileNotifier, FileState>(
  (ref) => FileNotifier(),
);

Future<bool> downloadFile(String fileUrl) async {
  final Uri url = Uri.parse(fileUrl);
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
    return true;
  } catch (e) {
    print('Error al intentar abrir la URL: $e');
    return false;
  }
}

final preloadFilesProvider = FutureProvider<void>((ref) async {
  final user = await ref.watch(authProvider.future);
  if (user == null) return;

  final notifier = ref.read(fileProvider.notifier);

  await Future.wait([
    for (final type in FileType.values) notifier.fetchAllFilesOfType(user.id, type),
  ]);
});
