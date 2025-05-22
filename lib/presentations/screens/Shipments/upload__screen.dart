import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutrabit_paciente/core/services/event_service.dart';
import 'package:nutrabit_paciente/core/utils/file_picker_util.dart';

class UploadFoodScreen extends StatefulWidget {
  final DateTime initialDate;

  const UploadFoodScreen({super.key, required this.initialDate});

  @override
  State<UploadFoodScreen> createState() => _UploadFoodScreenState();
}

class _UploadFoodScreenState extends State<UploadFoodScreen> {
  final EventService _eventService = EventService();

  PlatformFile? selectedFile;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate;
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null && selectedDateTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime!.year,
          selectedDateTime!.month,
          selectedDateTime!.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> pickFile() async {
    final file = await pickImageFile();
    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  Future<void> uploadAndSaveEvent() async {
  if (selectedFile == null || selectedDateTime == null) return;

  // Determinar si estamos en Web o no, y obtener los bytes del archivo
  Uint8List? fileBytes;

  if (kIsWeb) {
    fileBytes = selectedFile!.bytes;
  } else {
    if (selectedFile!.path != null) {
    final file = File(selectedFile!.path!); // import 'dart:io';
    fileBytes = await file.readAsBytes();
}
  }

  if (fileBytes == null) {
    print('No se pudo leer el archivo.');
    return;
  }

  await _eventService.uploadEvent(
    fileBytes: fileBytes,
    fileName: selectedFile!.name,
    title: titleController.text,
    description: descriptionController.text,
    dateTime: selectedDateTime!,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEDB),
      appBar: const UploadFoodAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            PickTimeField(
              selectedDateTime: selectedDateTime,
              onPickTime: pickTime,
            ),
            const SizedBox(height: 24),
            FilePickerField(
              selectedFile: selectedFile,
              onPickFile: pickFile,
            ),
            const SizedBox(height: 24),
            TitleField(controller: titleController),
            const SizedBox(height: 16),
            DescriptionField(controller: descriptionController),
            const SizedBox(height: 32),
            SubmitButton(
              onPressed: () async {
                await uploadAndSaveEvent();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Evento guardado correctamente')),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UploadFoodAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UploadFoodAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDEEDB),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text('Enviar archivos', style: TextStyle(color: Colors.black)),
    );
  }
}

class PickTimeField extends StatelessWidget {
  final DateTime? selectedDateTime;
  final VoidCallback onPickTime;

  const PickTimeField({
    super.key,
    required this.selectedDateTime,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Día y horario', style: TextStyle(color: Color(0xFFDC607A))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDC607A)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDateTime != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime!)
                      : 'Programar',
                  style: const TextStyle(color: Colors.black),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilePickerField extends StatelessWidget {
  final PlatformFile? selectedFile;
  final VoidCallback onPickFile;

  const FilePickerField({
    super.key,
    required this.selectedFile,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Adjuntá una foto o archivo', style: TextStyle(color: Color(0xFFDC607A))),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPickFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          child: const Text('Seleccionar archivo'),
        ),
        if (selectedFile != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.attach_file),
              Expanded(child: Text(selectedFile!.name)),
            ],
          ),
        ]
      ],
    );
  }
}

class TitleField extends StatelessWidget {
  final TextEditingController controller;

  const TitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Título', style: TextStyle(color: Color(0xFFDC607A))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Ej: Merienda',
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Descripción', style: TextStyle(color: Color(0xFFDC607A))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Ej: Té verde con tostadas',
            ),
          ),
        ),
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC607A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Enviar', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}