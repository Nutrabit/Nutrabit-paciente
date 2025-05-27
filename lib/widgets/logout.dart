import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';

class Logout extends ConsumerStatefulWidget {
  const Logout({super.key});

  @override
  ConsumerState<Logout> createState() => _LogoutState();
}

class _LogoutState extends ConsumerState<Logout> {
 void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cerrar sesión?'),
          content: const Text('¿Estás segura/o de que querés cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo
                final result = await ref.read(authProvider.notifier).logout();
                if (result == true) {
                  if (mounted) context.go('/login');
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al cerrar sesión')),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFD7F9DE),
                    foregroundColor: Color(0xFF606060),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
}
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
      tooltip: 'Cerrar sesión',
      onPressed: () => _confirmLogout(context),
    );
  }
}