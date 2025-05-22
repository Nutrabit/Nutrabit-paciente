import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/file_model.dart';
import 'package:nutrabit_paciente/core/models/file_type.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/file_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/files/pdfViewer.dart';

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(authProvider);
    final preload = ref.watch(preloadFilesProvider);

    if (appUser is AsyncLoading || preload is AsyncLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (appUser is AsyncError || appUser.value == null) {
      Future.microtask(
        () => Navigator.of(context).pushReplacementNamed('/login'),
      );
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis archivos'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      backgroundColor: Color(0xFFFDEEDB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              FileType.values
                  .map((type) => FileTypeExpansionTile(type: type))
                  .toList(),
        ),
      ),
    );
  }
}

class FileTypeExpansionTile extends ConsumerWidget {
  final FileType type;

  const FileTypeExpansionTile({required this.type, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileState = ref.watch(fileProvider);
    final List<FileModel> files = fileState.filesByType[type] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(type),
          title: Text(
            type.pluralDescription,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Icon(type.icon, color: Colors.black54),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          children:
              files.isEmpty
                  ? const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Aún no has recibido archivos de este tipo'),
                    ),
                  ]
                  : [
                    for (int i = 0; i < files.length; i++) ...[
                      FileListTile(file: files[i]),
                      if (i < files.length - 1)
                        const Divider(height: 1, thickness: 1),
                    ],
                  ],
        ),
      ),
    );
  }
}

class FileListTile extends ConsumerWidget {
  final FileModel file;

  const FileListTile({required this.file, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileState = ref.watch(fileProvider);
    final notifier = ref.read(fileProvider.notifier);

    final isDownloading = fileState.downloading[file.id] ?? false;
    final isDownloaded = fileState.downloaded[file.id] ?? false;

    return ListTile(
      title: Text(file.title),
      subtitle: Text('Fecha: ${formatDate(file.date)}'),
      trailing: Wrap(
        spacing: 8,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => PdfViewerScreen(url: file.url, title: file.title),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf, size: 20),
            // label: const Text(''),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          isDownloading
              ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : IconButton(
                onPressed:
                    isDownloaded
                        ? null
                        : () async {
                          notifier.setDownloading(file.id, true);
                          final success = await downloadFile(file.url);
                          notifier.setDownloading(file.id, false);
                          if (success) {
                            notifier.setDownloaded(file.id, true);
                          }
                        },
                icon: Icon(
                  isDownloaded ? Icons.check_circle : Icons.download,
                  size: 20,
                ),
                //label: Text(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
