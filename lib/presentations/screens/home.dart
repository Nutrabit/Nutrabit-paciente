import 'package:flutter/material.dart';
import 'package:nutrabit_paciente/widgets/contactButton.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Add your widgets here
          ],
        ),
      ),
      floatingActionButton: UrlFloatingActionButton(
        url: 'https://api.whatsapp.com/send?phone=5491167999237&text=Hola%20Flor!%20Me%20interesa%20m%C3%A1s%20informaci%C3%B3n%20sobre%20las%20consultas%20%F0%9F%A6%A6%20Gracias!',
        iconImage: 'assets/img/whatsapp.svg',
        iconSize: 35,
        
        
      ),
    );
  }
}