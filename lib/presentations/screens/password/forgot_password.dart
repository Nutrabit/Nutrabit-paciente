import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/providers/change_password_provider.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  //Se ejecuta al pulsar el botón “Enviar email de recuperación”
  void sendEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingrese un email válido.')));
    } else {
      // Se llama al método del provider
      ref.read(changePasswordProvider.notifier).sendPasswordResetEmail(email);
    }
  }

  void showPopup() {
    showGenericPopupBack(
      context: context,
      message:
          '¡Email enviado!\nRevisá tu bandeja de entrada para restablecer tu contraseña.',
      id: '/login',
      onNavigate: (ctx, route) {
        ctx.go(route); // va al login
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(changePasswordProvider);

    ref.listen<AsyncValue<void>>(changePasswordProvider, (prev, next) {
      next.when(
        loading: () {},
        data: (_) {
          if (prev is AsyncLoading && next is AsyncData) {
            showPopup();
          }
        },

        error: (err, _) {
          final msg =
              (err is FirebaseAuthException)
                  ? err.message ?? err.code
                  : err.toString();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $msg')));
        },
      ); 
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
        backgroundColor: const Color(0xFFFEECDA),
        leading: BackButton(
          onPressed: () {
            context.go('/login');
          },
        ),
      ),
      backgroundColor: const Color(0xFFFEECDA),
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Enviar email de recuperación'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
