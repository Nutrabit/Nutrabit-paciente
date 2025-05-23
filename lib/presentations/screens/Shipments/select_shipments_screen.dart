import 'package:flutter/material.dart';

class SelectShipmentsScreen extends StatelessWidget {
  const SelectShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEDB),
      appBar: const SelectShipmentsAppBar(),
      body: const SelectShipmentsBody(),
    );
  }
}

class SelectShipmentsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectShipmentsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDEEDB),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        'Envíos',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
      ),
    );
  }
}

class SelectShipmentsBody extends StatelessWidget {
  const SelectShipmentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Image.asset('assets/img/clip.png', width: 120),
        ),
        const SizedBox(height: 40),
        const ShipmentOptionButton(label: 'Subir imagen de comida'),
        const SizedBox(height: 16),
        const ShipmentOptionButton(label: 'Subir imagen de suplemento'),
        const SizedBox(height: 16),
        const ShipmentOptionButton(label: 'Subir análisis de sangre'),
      ],
    );
  }
}

class ShipmentOptionButton extends StatelessWidget {
  final String label;

  const ShipmentOptionButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDC607A), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black),
          onTap: () {
            // TODO: Queda en veremos dependiendo de cómo sea el flujo que se defina
          },
        ),
      ),
    );
  }
}