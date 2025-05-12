import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/file_picker_util.dart';

class FileState {
  final List<SelectedFile> files;

  FileState({this.files = const []});

  FileState copyWith({List<SelectedFile>? files}) {
    return FileState(files: files ?? this.files);
  }
}

class FileNotifier extends StateNotifier<FileState> {
  FileNotifier() : super(FileState());

  void addFile(SelectedFile newFile) {
    final updatedList = [...state.files, newFile];
    state = state.copyWith(files: updatedList);
  }

  void removeFile(SelectedFile fileToRemove) {
    final updatedList = state.files.where((f) => f != fileToRemove).toList();
    state = state.copyWith(files: updatedList);
  }

  void clear() {
    state = FileState();
  }
}

final fileProvider = StateNotifierProvider<FileNotifier, FileState>(
  (ref) => FileNotifier(),
);