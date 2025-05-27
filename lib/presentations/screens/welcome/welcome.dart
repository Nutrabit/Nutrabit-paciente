import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var freeSpace = screenHeight * 0.35;
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 238, 219, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: freeSpace),
                      Row(
                        
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                          Text(
                              '¡Bienvenido',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.11,
                                color: Color.fromRGBO(227, 126, 142, 1),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                          Text(
                              'a tu nuevo',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.09,

                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(153, 159, 127, 1),
                              ),
                            ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                          Text(
                              'estilo de vida!',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.09,

                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(153, 159, 127, 1),
                              ),
                            ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                        ],
                      ),

                      SizedBox(height: freeSpace),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
