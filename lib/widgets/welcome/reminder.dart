import 'package:flutter/material.dart';

class Reminder extends StatelessWidget {
  const Reminder({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: //SafeArea( child: 
        SingleChildScrollView( child: 
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/img/rectangleGreen.png'), width: screenWidth,
                  fit: BoxFit.cover,),
                //Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // children: [
                    Text(
                      '¡Importante recordar!',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color.fromRGBO(227, 126, 142, 1),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Image(image: AssetImage('assets/img/AlimentoMiCuerpo.png'), fit: BoxFit.fill,
                      width: screenWidth * 0.5,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'La salud es multifactorial. ¿Qué significa esto?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(153, 159, 127, 1),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tener una alimentación saludable es sumamente importante, pero recordá poner el mismo énfasis en regular los niveles de estrés, realizar actividad física, descansar adecuadamente y trabajar en tu salud mental.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(153, 159, 127, 1),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              //],
            //),
          ),
        //),
      ),
    );
  }
}
