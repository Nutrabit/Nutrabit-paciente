import 'package:flutter/material.dart';

class DetalleDiaCalendario extends StatelessWidget {
  final String fecha;
  const DetalleDiaCalendario({required this.fecha, super.key});

  @override
  Widget build(BuildContext context) {
    
    // #####################################
    //HICE ESTO PARA PROBAR LA REDIRECCION
    // #####################################

    return Scaffold( body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Detalles del día',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Fecha seleccionada: $fecha',
            style: TextStyle(fontSize: 18),
          ),
        
        ],
      ),
    ));
  }
}