import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();
  bool _isLoading = false;
  bool currentPasswordVisible = false;
  bool nextPasswordVisible = false;
  bool repeatPasswordVisible = false;

  void changePassword() {
    final current = _currentController.text.trim();
    final next = _newController.text.trim();
    final repeat = _repeatController.text.trim();

    if (current.isEmpty || next.isEmpty || repeat.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
    } else {
      // Dispara la actualización de contraseña a través del provider
      setState(() => _isLoading = true);
      ref
          .read(authProvider.notifier)
          .updatePassword(
            currentPassword: current,
            newPassword: next,
            repeatPassword: repeat,
          )
          .whenComplete(() {
            setState(() => _isLoading = false);
          });
    }
  }
  void showPopup() {
    showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
                '¡Contraseña actualizada correctamente!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF2F2F2F),
                ),
              ),
        content: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Por favor, vuelva a iniciar sesión.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFF2F2F2F),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFB5D6B2),
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Aceptar',
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

  @override
  Widget build(BuildContext context) {
    // Escucha el estado de carga/éxito/error del provider
    ref.listen<AsyncValue<void>>(authProvider, (prev, next) {
      next.when(
        loading: () {},
        data: (_) {
          showPopup();
        },
        error: (err, _) {
          final msg =
              err is FirebaseAuthException
                  ? (err.message ?? err.code)
                  : err.toString();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentController,
              obscureText: !currentPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    icon: Icon(
                      currentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        currentPasswordVisible = !currentPasswordVisible;
                      });
                    },
                  ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newController,
              obscureText: !nextPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    icon: Icon(
                      nextPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        nextPasswordVisible = !nextPasswordVisible;
                      });
                    },
                  ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _repeatController,
              obscureText: !repeatPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Repetir contraseña',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    icon: Icon(
                      repeatPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        repeatPasswordVisible = !repeatPasswordVisible;
                      });
                    },
                  ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : changePassword,
              style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(220, 96, 122, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
