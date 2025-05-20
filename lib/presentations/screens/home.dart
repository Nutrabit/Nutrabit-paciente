import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/widgets/contactButton.dart';
import 'package:nutrabit_paciente/widgets/homeButton.dart';
import 'package:nutrabit_paciente/widgets/CustombottomNavBar.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(authProvider);
    final bool isLoggedIn = appUser.value != null;

    if (appUser is AsyncLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEECDA),
      bottomNavigationBar: CustomBottomAppBar(
        currentIndex: 0,
        onItemSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              //context.go('/notificaciones');
              break;
            case 2:
              context.go('/perfil');
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              'assets/img/encabezadoHome.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,

              child: Row(
                children: [
                  isLoggedIn
                      ? Text(
                        '¡Aloha ${appUser.value?.name}!',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                      : Text(
                        '¡Aloha!',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  SvgPicture.asset(
                    'assets/img/lemonsHome.svg',
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.30,
              left: MediaQuery.of(context).size.width * 0.1,

              child: Row(
                children: [
                  Hero(
                    tag: 'homebutton-mis-archivos',
                    child: HomeButton(
                      imagePath:
                          'assets/img/ae36775c8e0c536b6c134e271841777229e6210a.png',
                      text: 'Mis archivos',
                      onPressed: () {
                        context.go('/descargas');
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
                        //context.go('/publicidades');
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
              top: MediaQuery.of(context).size.height * 0.50,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Row(
                children: [
                  Hero(
                    tag: 'homebutton-Envíos',
                    child: HomeButton(
                      imagePath:
                          'assets/img/d4fbb7df798270b5e6d5c38f4faf310cc2cdf3fa.png',
                      text: 'Envíos',
                      onPressed: () {
                        context.go('/archivos/subir');
                      },
                      width: MediaQuery.of(context).size.width * 0.35,
                      imageHeight: MediaQuery.of(context).size.height * 0.11,
                      baseHeight: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),

                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Hero(
                    tag: 'homebutton-Calendario',
                    child: HomeButton(
                      imagePath:
                          'assets/img/084fb2c3881361e7e5ce3fb5463622843c33bf3b.png',
                      text: 'Calendario',
                      onPressed: () {
                        //context.go('/calendario');
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
              top: MediaQuery.of(context).size.height * 0.70,
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
                        //context.go('/listasInteres');
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
