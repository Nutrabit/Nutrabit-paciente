import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmIPatient extends StatelessWidget {
  const AmIPatient({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      
      backgroundColor: Color.fromRGBO(253, 238, 219, 1),
      body: 
        SingleChildScrollView( child: 
          Center(
            child:
            
            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80,),  
                SizedBox(height: screenHeight * 0.01),
                Image(
                  image: AssetImage('assets/img/logoName.png'),
                  width: screenHeight * 0.25,
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(220, 96, 122, 1),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                    ),
                    child: Text("Soy paciente"),
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  width: screenWidth * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(220, 96, 122, 1),
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("No soy paciente"),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
