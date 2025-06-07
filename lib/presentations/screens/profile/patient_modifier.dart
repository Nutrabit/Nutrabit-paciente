import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';
import 'package:nutrabit_paciente/presentations/providers/user_provider.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_detail.dart';


class PatientModifier extends ConsumerWidget {
  final String id;
  const PatientModifier({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    if (user == null || user.id != id) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final heightController = TextEditingController(text: user.height.toString());
    final weightController = TextEditingController(text: user.weight.toString());
    final List<String> validGender = ['Masculino', 'Femenino', 'Otro'];
    final goals = [
      {'label': 'Perder grasa', 'image': 'assets/img/perder_grasa.png'},
      {'label': 'Mantener peso', 'image': 'assets/img/mantener_peso.png'},
      {'label': 'Aumentar peso', 'image': 'assets/img/aumentar_peso.png'},
      {'label': 'Ganar músculo', 'image': 'assets/img/ganar_musculo.png'},
      {'label': 'Crear hábitos saludables', 'image': 'assets/img/habitos.png'},
      
    ];

    String? selectedGender = user.gender;
    String? selectedGoal = user.goal;
    File? pickedImage;
    DateTime? _birthday = user.birthday;


return Scaffold(
  appBar: AppBar(
    title: const Text('Modificar perfil'),
    centerTitle: true,
    backgroundColor: Colors.white,
    leading: const BackButton(),
    elevation: 0,
  ),
  body: StatefulBuilder(
    builder: (context, setState) => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 16),
          ProfileImagePicker(
            profilePicUrl: user.profilePic,
            pickedImage: pickedImage,
            onPick: (image) => setState(() => pickedImage = image),
            onDelete: () async {
              try {
                await userNotifier.deleteProfileImage();
                await userNotifier.refreshUser();
                setState(() {
                  pickedImage = null;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al eliminar la imagen: $e')),
                );
              }
            },
            userId: id,
          ),
              const SizedBox(height: 24),
              HeightWeightInputs(heightController: heightController, weightController: weightController),
              const SizedBox(height: 12),
              Row(
                  children: [
                    Expanded(child: _BirthDayPicker(birthday: _birthday, onDateChanged: (date) => setState(() => _birthday = date))),
                    const SizedBox(width: 12),
                    Expanded(child: _GenderDropdown(selectedGender: selectedGender, onChanged: (value) => setState(() => selectedGender = value), validGender: validGender)),
                  ],
                ),
              const SizedBox(height: 12),
              GoalSelector(
                goals: goals,
                selectedGoal: selectedGoal,
                onSelect: (goal) => setState(() => selectedGoal = goal),
              ),
              const SizedBox(height: 40),
              SaveButton(onPressed: () async {
                try {
                  await userNotifier.updateFields({
                    'height': int.tryParse(heightController.text.trim().substring(0, heightController.text.trim().length.clamp(0, 3))) ?? 0,
                    'weight': int.tryParse(weightController.text.trim().substring(0, weightController.text.trim().length.clamp(0, 3))) ?? 0,
                    'gender': selectedGender ?? '',
                    'goal': selectedGoal ?? '',
                    'birthday': _birthday,
                    'deletedAt': null,
                  });
                  showDialog(
                    context: context,
                    builder: (_) => SuccessDialog(id: id),
                  );
                } catch (e) {
                  print('Error al actualizar paciente: $e');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}


class ImagePickerDialog extends ConsumerStatefulWidget {
  final String userId;
  final String? profilePicUrl;
  final void Function(File?) onImageChanged;
  final Future<void> Function() onDelete;

  const ImagePickerDialog({
    super.key,
    required this.userId,
    required this.profilePicUrl,
    required this.onImageChanged,
    required this.onDelete,
  });

  @override
  ConsumerState<ImagePickerDialog> createState() => _ImagePickerDialogState();
}
class _ImagePickerDialogState extends ConsumerState<ImagePickerDialog> {
  File? _selectedImage;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEECDa),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const Text(
                    'Foto de perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B8680),
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.black),

                if (_selectedImage != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.black),
                ],

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEECDa),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.black87),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(source: ImageSource.camera);
                          if (picked != null) {
                            setState(() {
                              _selectedImage = File(picked.path);
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo_library_outlined, size: 30, color: Colors.black87),
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            setState(() {
                              _selectedImage = File(picked.path);
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 30, color: Colors.black87),
                        onPressed: () async {
                          await widget.onDelete();
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                      ),
                      if (_selectedImage != null)
                        IconButton(
                          icon: const Icon(Icons.check, size: 30, color: Colors.green),
                          onPressed: () async {
                            final userNotifier = ref.read(userProvider.notifier);
                            setState(() {
                              _isUploading = true;
                            });

                            try {
                              final newUrl = await userNotifier.uploadProfileImage(_selectedImage!);
                              widget.onImageChanged(_selectedImage!);
                              if (mounted) Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Imagen actualizada con éxito')),
                              );
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al subir la imagen: $e')),
                                );
                                setState(() {
                                  _isUploading = false;
                                });
                              }
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HeightWeightInputs extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;

  const HeightWeightInputs({
    required this.heightController,
    required this.weightController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTextField(heightController, 'Altura', 'cm')),
        const SizedBox(width: 12),
        Expanded(child: _buildTextField(weightController, 'Peso', 'kg')),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, String suffix) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(3),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: inputDecoration(hint, suffix: suffix),
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final String? selectedGender;
  final List<String> validGender;
  final ValueChanged<String?> onChanged;

  const _GenderDropdown({
    required this.selectedGender,
    required this.onChanged,
    required this.validGender,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: validGender.contains(selectedGender) ? selectedGender : null,
      decoration: inputDecoration('Sexo'),
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      items: validGender
          .map((sexo) => DropdownMenuItem(
                value: sexo,
                child: Text(sexo),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class GoalSelector extends StatelessWidget {
  final List<Map<String, String>> goals;
  final String? selectedGoal;
  final ValueChanged<String> onSelect;

  const GoalSelector({required this.goals, required this.selectedGoal, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Objetivo', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Center(
          child: Wrap(
            spacing: 15,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: goals.map(
              (goal) => _GoalBox(
                goal: goal,
                isSelected: selectedGoal == goal['label'],
                onTap: () => onSelect(goal['label']!),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _GoalBox extends StatelessWidget {
  final Map<String, String> goal;
  final VoidCallback onTap;
  final bool isSelected;

  const _GoalBox({
    required this.goal,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Color(0xFFDC607A), width: 2)
              : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              goal['image']!,
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Center(
                child: Text(
                  goal['label']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC607A),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Guardar cambios', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String id;

  const SuccessDialog({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      content: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¡Perfil modificado!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF2F2F2F))),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 6),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => PatientDetail(id: id)));
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFB5D6B2),
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('VOLVER', style: TextStyle(fontSize: 14, color: Color(0xFF706B66))),
            ),
          ],
        ),
      ),
    );
  }
}

class _BirthDayPicker extends StatelessWidget {
  final DateTime? birthday;
  final ValueChanged<DateTime> onDateChanged;

  const _BirthDayPicker({super.key, 
    required this.birthday,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: birthday ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: birthday != null
                ? "${birthday!.day.toString().padLeft(2, '0')}/${birthday!.month.toString().padLeft(2, '0')}/${birthday!.year}"
                : '',
          ),
          decoration: inputDecoration('Nacimiento'),
        ),
      ),
    );
  }
}
class ProfileImagePicker extends StatelessWidget {
  final String? profilePicUrl;
  final File? pickedImage;
  final ValueChanged<File> onPick;
  final Future<void> Function() onDelete; 
  final String userId;

  const ProfileImagePicker({
  required this.profilePicUrl,
  required this.pickedImage,
  required this.onPick,
  required this.onDelete,
  required this.userId,
  super.key,
});

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = pickedImage != null
        ? FileImage(pickedImage!)
        : (profilePicUrl != null && profilePicUrl!.isNotEmpty)
            ? NetworkImage(profilePicUrl!)
            : const AssetImage('assets/img/avatar.jpg');

    return Center(
      child: Stack(
        children: [
          CircleAvatar(radius: 50, backgroundImage: imageProvider),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => ImagePickerDialog(
                  profilePicUrl: profilePicUrl,
                  userId: userId,
                  onImageChanged: (file) {
                    if (file != null) {
                      onPick(file);
                    } else {

                    }
                  },
                  onDelete: onDelete, 
                ),

                );
              },
              child: Container(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}