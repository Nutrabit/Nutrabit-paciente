import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 96, 122, 1),
      body: SafeArea( child: 
        SingleChildScrollView( child: 
          Center( child: 
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    Text(
                      '¡Atención!',
                      style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            'Esta app no busca reemplazar tu consulta con un profesional de la salud. Busca poder acompañarte y motivarte para que logres generar hábitos de bienestar y salud, abarcando diversas áreas: alimento, movimiento, descanso adecuado y gestión del estrés.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          SizedBox(height: 20),
                          Image(image: AssetImage('assets/img/nutriaAbrazo.png')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}