import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/app_user.dart';

class ProfileDynamicScreen extends ConsumerStatefulWidget {
  const ProfileDynamicScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileDynamicScreen> createState() => _ProfileDynamicScreenState();
}

class _ProfileDynamicScreenState extends ConsumerState<ProfileDynamicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _gender;
  DateTime? _birthday;
  bool _initialized = false;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _initializeIfNeeded(AppUser user) {
    if (_initialized) return;
    _heightController.text = user.height == 0 ? '' : user.height.toString();
    _weightController.text = user.weight == 0 ? '' : user.weight.toString();
    _gender = user.gender.isNotEmpty ? user.gender : null;
    _birthday = user.birthday;
    _initialized = true;
  }

  Future<void> _onNext() async {
    final currentUser = ref.read(userProvider);
    final changes = <String, dynamic>{};

    final height = int.tryParse(_heightController.text.trim());
    final weight = int.tryParse(_weightController.text.trim());

    if (height != null && height != currentUser?.height) changes['height'] = height;
    if (weight != null && weight != currentUser?.weight) changes['weight'] = weight;
    if (_gender != null && _gender != currentUser?.gender) changes['gender'] = _gender;
    if (_birthday != null && _birthday != currentUser?.birthday) changes['birthday'] = _birthday;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _gender == null || _birthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos obligatorios.")),
      );
      return;
    }

    try {
      if (changes.isNotEmpty) {
        await ref.read(userProvider.notifier).updateFields(changes);
      }
      if (!mounted) return;
      context.go('/login/validation/select_goal');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _initializeIfNeeded(user);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Cuéntame sobre ti',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const StepIndicator(currentStep: 0),
            const SizedBox(height: 16),
            LabeledField(label: 'Nombre', input: Text(user.name, style: const TextStyle(fontSize: 16))),
            LabeledField(label: 'Apellido', input: Text(user.lastname, style: const TextStyle(fontSize: 16))),
            LabeledField(
              label: 'Sexo *',
              input: GenderDropdown(
                value: _gender,
                onChanged: (v) => setState(() => _gender = v),
              ),
            ),
            LabeledField(
              label: 'Fecha de Nacimiento *',
              input: BirthdayPicker(
                date: _birthday,
                onDateSelected: (d) => setState(() => _birthday = d),
              ),
            ),
            HeightWeightFields(
              heightController: _heightController,
              weightController: _weightController,
            ),
            const SizedBox(height: 32),
            NextButton(onPressed: _onNext),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({this.totalSteps = 2, this.currentStep = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFD87B91) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final Widget input;

  const LabeledField({required this.label, required this.input, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          input,
        ],
      ),
    );
  }
}

class GenderDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const GenderDropdown({required this.value, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(border: InputBorder.none),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? 'Obligatorio' : null,
    );
  }
}

class BirthdayPicker extends StatelessWidget {
  final DateTime? date;
  final void Function(DateTime?) onDateSelected;

  const BirthdayPicker({required this.date, required this.onDateSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) onDateSelected(selectedDate);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date == null ? 'Selecciona una fecha' : DateFormat.yMMMd().format(date!),
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(Icons.calendar_today, size: 18),
        ],
      ),
    );
  }
}

class HeightWeightFields extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;

  const HeightWeightFields({required this.heightController, required this.weightController, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LabeledField(
            label: 'Altura (cm) *',
            input: TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'cm', border: InputBorder.none),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Obligatorio';
                final intValue = int.tryParse(value);
                if (intValue == null || intValue <= 0) return 'Debe ser un número válido';
                return null;
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: LabeledField(
            label: 'Peso (kg) *',
            input: TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'kg', border: InputBorder.none),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Obligatorio';
                final intValue = int.tryParse(value);
                if (intValue == null || intValue <= 0) return 'Debe ser un número válido';
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF909070),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Siguiente', style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
