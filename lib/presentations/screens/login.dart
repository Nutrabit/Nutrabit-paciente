import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/utils/decorations.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart' show rootBundle;

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  Future<void> _showPopUpFromFile(
    BuildContext context,
    String titulo,
    String assetPath,
  ) async {
    final contenido = await rootBundle.loadString(assetPath);
    final style = defaultAlertDialogStyle;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: style.shape,
      backgroundColor: style.backgroundColor,
      elevation: style.elevation,
      contentTextStyle: style.contentTextStyle,
      contentPadding: style.contentPadding,
            title: Text(titulo),
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(child: Text(contenido)),
            ),
            actions: [
              TextButton(
                style: style.buttonStyle,
                child: Text('Cerrar',style: style.buttonTextStyle),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicPadding = screenWidth * 0.20;
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 236, 216, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/img/rectangleWhite.png'),
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
                // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/img/logoInicio.png'),
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      const SizedBox(height: 20),
                      // Título
                      Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      //// Campos de texto
                      /// Email
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Contraseña
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contraseña',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      // Olvidaste tu contraseña
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.go('/recuperar-clave');
                            },
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Color.fromRGBO(130, 130, 130, 1),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Botón de submit
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final email = emailController.text;
                            final password = passwordController.text;
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Por favor complete todos los campos',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            final cred = ref
                                .read(authProvider.notifier)
                                .login(email, password)
                                .then((r) {
                                  // Si el usuario es paciente, redirigir a la pantalla de inicio
                                  if (r == true) {
                                    final appUser = ref.watch(authProvider);
                                    if (appUser.value?.createdAt ==
                                        appUser.value?.modifiedAt) {
                                      context.go('/login/validation');
                                    } else {
                                      context.go('/');
                                    }
                                  } else if (r == false) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    // Si el usuario no existe o la contraseña es incorrecta, mostrar un mensaje
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            emailController.text.isEmpty ||
                                                    passwordController
                                                        .text
                                                        .isEmpty
                                                ? Text(
                                                  'Por favor complete todos los campos',
                                                )
                                                : Text(
                                                  'Usuario y/o contraseña inválidos',
                                                ),
                                      ),
                                    );
                                  }
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(220, 96, 122, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              isLoading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text("Ingresar"),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Términos y condiciones
                      Text.rich(
                        TextSpan(
                          text: 'Al hacer clic en ingresar, acepta nuestros ',
                          style: TextStyle(
                            color: Color.fromRGBO(130, 130, 130, 1),
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: 'términos de servicio',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      _showPopUpFromFile(
                                        context,
                                        'Términos de servicio',
                                        'tos.txt',
                                      );
                                    },
                            ),
                            TextSpan(text: ' y nuestra '),
                            TextSpan(
                              text: 'política de privacidad',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      _showPopUpFromFile(
                                        context,
                                        'Política de privacidad',
                                        'privacidad.txt',
                                      );
                                    },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  //),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
