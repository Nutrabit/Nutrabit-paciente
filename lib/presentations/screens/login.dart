import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:flutter/gestures.dart';

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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicPadding = screenWidth * 0.20;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: dynamicPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: AssetImage('assets/img/logoInicio.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Título
              Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      context.go('/forgot-password');
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
                    setState(() {
                      isLoading = true;
                    });
                    final email = emailController.text;
                    final password = passwordController.text;
                    final cred = ref
                        .read(authProvider.notifier)
                        .login(email, password)
                        .then((r) {
                          // Si el usuario es paciente, redirigir a la pantalla de inicio
                          if (r == true) {
                            context.go('/');
                          } else if (r == false) {
                            setState(() {
                              isLoading = false;
                            });
                            // Si el usuario no existe o la contraseña es incorrecta, mostrar un mensaje
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
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
                              context.push('/terminos');
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
                              context.push('/privacidad');
                            },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
