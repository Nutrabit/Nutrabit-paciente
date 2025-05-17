import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/router/app-router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _redirected = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: (context, child) {
        // Redirigimos una única vez luego de que se construye el widget
        if (!_redirected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go(
              '/perfil/modificar',
              extra: 'jbMcfeHOSv2G9VPL5lM8',
            );
          });
          _redirected = true;
        }

        return child!;
      },
    );
  }
}
