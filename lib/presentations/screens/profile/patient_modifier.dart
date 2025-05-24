import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PatientModifier extends StatefulWidget {
  final String id;
  const PatientModifier({Key? key, required this.id}) : super(key: key);

  @override
  State<PatientModifier> createState() => _PatientModifierState();
}

class _PatientModifierState extends State<PatientModifier> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final List<String> gender = ['Masculino', 'Femenino', 'Otro'];

  String? _selectedGender;
  Map<String, dynamic>? _userData;
  final List<Map<String, String>> goals = [
    {'label': 'Perder grasa', 'image': 'assets/img/perder_grasa.png'},
    {'label': 'Mantener peso', 'image': 'assets/img/mantener_peso.png'},
    {'label': 'Aumentar peso', 'image': 'assets/img/aumentar_peso.png'},
    {'label': 'Ganar músculo', 'image': 'assets/img/ganar_musculo.png'},
    {'label': 'Crear hábitos saludables', 'image': 'assets/img/habitos.png'},
  ];
  String? _selectedGoal;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      setState(() {
        _userData = data;
        _heightController.text = data['height']?.toString() ?? '';
        _weightController.text = data['weight']?.toString() ?? '';
        _selectedGender = data['gender'] ?? 'Otro';
        _selectedGoal = data['goal']?.toString() ?? '';
      });
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _updatePatient() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.id)
          .update({
            'height':
                int.tryParse(
                  _heightController.text.trim().substring(
                    0,
                    _heightController.text.trim().length.clamp(0, 3),
                  ),
                ) ??
                0,
            'weight':
                int.tryParse(
                  _weightController.text.trim().substring(
                    0,
                    _weightController.text.trim().length.clamp(0, 3),
                  ),
                ) ??
                0,
            'gender': _selectedGender ?? '',
            'goal': _selectedGoal ?? '',
            'modifiedAt': FieldValue.serverTimestamp(),
            'deletedAt': null,
          });
      _showSuccessPopup();
    } catch (e) {
      print('Error al actualizar paciente: $e');
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          content: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¡Perfil modificado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PatientDetail(id: widget.id),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFB5D6B2),
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'VOLVER',
                    style: TextStyle(fontSize: 14, color: Color(0xFF706B66)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _uploadPickedImage() async {
    if (_pickedImage == null) return;
    String fileName =
        'profilePics/${widget.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    try {
      await storageRef.putFile(_pickedImage!);
      final url = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.id)
          .update({'profilePic': url});
      _pickedImage = null;
    } catch (e) {
      print('Error al subir la imagen: $e');
    }
  }

  void _showImagePickerPopup() {
    final profilePic = _userData?['profilePic'];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                width: 240,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD7F1CE),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Adjuntar archivo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, color: Colors.black),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEECDa),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Text(
                              _pickedImage != null
                                  ? _pickedImage!.path.split('/').last
                                  : (profilePic != null && profilePic.isNotEmpty
                                      ? 'Imagen actual seleccionada'
                                      : 'No hay imagen'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  'Galería',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF8B8680),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Botón "+" para seleccionar imagen
                              IconButton(
                                icon: const Icon(Icons.add, size: 28),
                                onPressed: () async {
                                  final picker = ImagePicker();
                                  final picked = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (picked != null) {
                                    setStateDialog(() {
                                      _pickedImage = File(picked.path);
                                    });
                                  }
                                },
                              ),
                              // Botón "-" para quitar imagen / borrar imagen
                              IconButton(
                                icon: const Icon(Icons.remove, size: 28),
                                onPressed: () async {
                                  try {
                                    if (_pickedImage != null) {
                                      // Descartar la imagen en memoria
                                      setStateDialog(() {
                                        _pickedImage = null;
                                      });
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Imagen nueva descartada',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      // Borrar imagen almacenada en Firestore + Storage
                                      if (profilePic != null &&
                                          profilePic.isNotEmpty) {
                                        final ref = FirebaseStorage.instance
                                            .refFromURL(profilePic);
                                        await ref.delete();

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.id)
                                            .update({'profilePic': ''});

                                        setState(() {
                                          _userData!['profilePic'] = '';
                                        });
                                        setStateDialog(() {});

                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Imagen eliminada correctamente',
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'No hay imagen para eliminar',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error al eliminar la imagen: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8B8680),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_pickedImage != null) {
                                    // Subir la imagen seleccionada
                                    String fileName =
                                        'profilePics/${widget.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                                    final storageRef = FirebaseStorage.instance
                                        .ref()
                                        .child(fileName);

                                    try {
                                      await storageRef.putFile(_pickedImage!);
                                      final url =
                                          await storageRef.getDownloadURL();

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.id)
                                          .update({'profilePic': url});

                                      setState(() {
                                        _userData!['profilePic'] = url;
                                        _pickedImage = null;
                                      });

                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Imagen subida correctamente',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error al subir la imagen: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC607A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                child: const Text(
                                  'Confirmar',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profilePic =
        _pickedImage != null
            ? FileImage(_pickedImage!)
            : (_userData!['profilePic'] != null &&
                (_userData!['profilePic'] as String).isNotEmpty)
            ? NetworkImage(_userData!['profilePic'])
            : const AssetImage('assets/img/avatar.jpg') as ImageProvider;
    final firstRow = goals.take(3).toList();
    final secondRow = goals.skip(3).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modificar información',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(radius: 50, backgroundImage: profilePic),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showImagePickerPopup,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _heightController,
                    'Altura',
                    keyboardType: TextInputType.number,
                    suffix: 'cm',
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _weightController,
                    'Peso',
                    keyboardType: TextInputType.number,
                    suffix: 'kg',
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: gender.contains(_selectedGender) ? _selectedGender : null,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: 'Nivel de actividad',
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFDC607A),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFDC607A),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),

              selectedItemBuilder: (BuildContext context) {
                return gender.map((nivel) {
                  return Center(
                    child: Text(
                      nivel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList();
              },

              items:
                  gender.map((nivel) {
                    return DropdownMenuItem(
                      value: nivel,
                      child: Center(
                        child: Text(nivel, textAlign: TextAlign.center),
                      ),
                    );
                  }).toList(),

              onChanged: (value) => setState(() => _selectedGender = value),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Text(
                      "Objetivo",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          firstRow.map((goal) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                              child: _GoalBox(goal: goal,   isSelected: _selectedGoal == goal['label'],
                              onTap: () => setState(() => _selectedGoal = goal['label'])),
                            );
                          }).toList(),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          secondRow.map((goal) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                              child: _GoalBox(goal: goal,   isSelected: _selectedGoal == goal['label'],
                              onTap: () => setState(() => _selectedGoal = goal['label'])),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: ElevatedButton(
                onPressed: _updatePatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC607A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    String? suffix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixText:
              (controller.text.isNotEmpty && suffix != null) ? suffix : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDC607A), width: 2.0),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDC607A), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  }
  class _GoalBox extends StatelessWidget {
  final Map<String, String> goal;
  final VoidCallback onTap;
  final bool isSelected;

  const _GoalBox({required this.goal, required this.onTap, required this.isSelected, super.key});
  @override
 Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Color(0xFFDC607A), width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Image.asset(
              goal['image']!,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              goal['label']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  }
