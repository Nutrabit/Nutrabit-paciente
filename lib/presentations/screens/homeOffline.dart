import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/widgets/contactButton.dart';
import 'package:nutrabit_paciente/widgets/homeButton.dart';
import 'package:nutrabit_paciente/widgets/custombottomNavBar.dart';

class HomeOffline extends StatelessWidget {
  const HomeOffline({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: const Color(0xFFFEECDA),
      bottomNavigationBar: CustomBottomAppBar(
        currentIndex: 0,
        onItemSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              //context.push('/notificaciones');
              break;
            case 2:
              context.push('/login');
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height *
              1.2, // o más si necesitás más espacio
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                'assets/img/encabezadoHome.svg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.1,

                child: Row(
                  children: [
                    Text(
                      '¡Aloha!',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                    SvgPicture.asset(
                      'assets/img/lemonsHome.svg',
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.40,
                left: MediaQuery.of(context).size.width * 0.1,

                child: Row(
                  children: [
                    Hero(
                      tag: 'homebutton-Calendario',
                      child: HomeButton(
                        imagePath:
                            'assets/img/084fb2c3881361e7e5ce3fb5463622843c33bf3b.png',
                        text: 'Calendario',
                        onPressed: () {
                          //context.push('/calendario');
                        },
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Hero(
                      tag: 'homebutton-talleres',
                      child: HomeButton(
                        imagePath:
                            'assets/img/ee19a2bb0ba198a476f373bb3ee3f9e64b995714.png',
                        text: 'Talleres',
                        onPressed: () {
                          context.push('/publicidades');
                        },
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              
              Positioned(
                top: MediaQuery.of(context).size.height * 0.60,
                left: MediaQuery.of(context).size.width * 0.30,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Hero(
                      tag: 'homebutton-Recomendacionesv',
                      child: HomeButton(
                        imagePath:
                            'assets/img/602f21c7b3661d6df85fe352c44a38d0007ad10b.png',
                        text: 'Recomendaciones',
                        onPressed: () {
                          context.push('/listasInteres');
                        },
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),

                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UrlFloatingActionButton(
            url: 'https://www.instagram.com/nutri.florcabral/',
            iconImage: 'assets/img/instagram.svg',
            iconSize: 45,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          UrlFloatingActionButton(
            url:
                'https://api.whatsapp.com/send?phone=5491167999237&text=Hola%20Flor!%20Me%20interesa%20m%C3%A1s%20informaci%C3%B3n%20sobre%20las%20consultas%20%F0%9F%A6%A6%20Gracias!',
            iconImage: 'assets/img/whatsapp.svg',
            iconSize: 35,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
