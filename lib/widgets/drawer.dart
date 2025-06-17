// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/widgets/logout.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFEECDA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 150, //
            child: DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFDC607A)),
              child: Row(
                children: [
                  Text(
                    'Menú',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Spacer(),
                  CloseButton(style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Cambiar contraseña'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/cambiar-clave');
            },
          ),

          const Divider(),

          const Spacer(),

          Row(children: const [Logout()]),
          

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
