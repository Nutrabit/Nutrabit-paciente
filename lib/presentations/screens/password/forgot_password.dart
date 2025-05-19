import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool emailSent = false;

  //Se ejecuta al pulsar el botón “Enviar email de recuperación”
  void sendEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese un email válido.')));
    } else {
      emailSent = true;
      // Se llama al método del provider
      ref.read(authProvider.notifier).sendPasswordResetEmail(email);
    }
  }

  void showPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            '¡Email enviado!',
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
                  'Revisa tu bandeja de entrada para restablecer tu contraseña.',
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
                    'Aceptar',
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<void>>(authProvider, (prev, next) {
      if (!emailSent) return;
      next.when(
        loading: () {},
        data: (_) {
          if (prev is AsyncLoading && next is AsyncData) {
            showPopup();
          }
        },

       error: (err, _) {
          final msg = (err is FirebaseAuthException)
              ? err.message ?? err.code
              : err.toString();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $msg')));

        },
      ); // ← así, dentro de los paréntesis de ref.listen
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ingresar email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Tu email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Botón de envío
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState is AsyncLoading ? null : sendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(220, 96, 122, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    authState is AsyncLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        // ✅ Texto normal si no está cargando
                        : const Text('Enviar email de recuperación'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
