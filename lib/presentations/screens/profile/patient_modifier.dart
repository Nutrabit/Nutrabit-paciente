import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  File? _pickedImage; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(widget.id).get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      setState(() {
        _userData = data;
        _heightController.text = data['height']?.toString() ?? '';
        _weightController.text = data['weight']?.toString() ?? '';
        _selectedGender = data['gender'] ?? 'Otro';


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
      await FirebaseFirestore.instance.collection('users').doc(widget.id).update({
        'height': int.tryParse(_heightController.text.trim()) ?? 0,
        'weight': int.tryParse(_weightController.text.trim()) ?? 0,
        'gender': _selectedGender ?? '',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
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
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFB5D6B2),
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'VOLVER',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF706B66), 
                  ),
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
    String fileName = 'profilePics/${widget.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    try {
      await storageRef.putFile(_pickedImage!);
      final url = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(widget.id).update({
        'profilePic': url,
      });
      _pickedImage = null; // Limpiar la imagen local después de subir
     
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(106)),
          child: Container(
            width: 240,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD7F1CE),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          _pickedImage != null
                              ? _pickedImage!.path
                              : (profilePic ?? '<img src="images/picture.jpg">'),
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 120),
                              child: IconButton(
                                icon: const Icon(Icons.add, size: 28),
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                              ),
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
                              await _uploadPickedImage();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC607A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
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

    final profilePic = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (_userData!['profilePic'] != null && (_userData!['profilePic'] as String).isNotEmpty)
            ? NetworkImage(_userData!['profilePic'])
            : const AssetImage('assets/images/avatar.png') as ImageProvider;

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
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profilePic,
                  ),
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
                Expanded(child: _buildTextField(_heightController, 'Altura', keyboardType: TextInputType.number, suffix: 'cm')),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_weightController, 'Peso', keyboardType: TextInputType.number, suffix: 'kg')),
              ],
            ),
            const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: gender.contains(_selectedGender) ? _selectedGender : null,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'Nivel de actividad',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFDC607A), width: 2.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFDC607A), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
                
                selectedItemBuilder: (BuildContext context) {
                  return gender.map((nivel) {
                    return Center(
                      child: Text(
                        nivel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList();
                },

                items: gender.map((nivel) {
                  return DropdownMenuItem(
                    value: nivel,
                    child: Center(
                      child: Text(
                        nivel,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
                
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
           
            const SizedBox(height: 280),
            Center(
              child: ElevatedButton(
                onPressed: _updatePatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC607A),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Guardar cambios', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType? keyboardType, String? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixText: (controller.text.isNotEmpty && suffix != null) ? suffix : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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