import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var freeSpace = screenHeight * 0.35;
    return Scaffold(
        backgroundColor: Color.fromRGBO(253, 238, 219, 1),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: freeSpace),
                Text(
                  '¡Bienvenido',
                  style: TextStyle(
                    fontSize: 50,
                    color: Color.fromRGBO(227, 126, 142, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'a tu nuevo estilo de vida!',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(153, 159, 127, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}