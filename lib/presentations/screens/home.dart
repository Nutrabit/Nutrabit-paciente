import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';
import 'package:nutrabit_paciente/widgets/contactButton.dart';
import 'package:nutrabit_paciente/widgets/homeButton.dart';
import 'package:nutrabit_paciente/widgets/custombottomNavBar.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _assetsLoaded = false;

  @override
  void initState() {
    super.initState();
    _precacheAssets();
  }

  Future<void> _precacheAssets() async {
    await Future.wait([
      precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          'assets/img/encabezadoHome.svg',
        ),
        null,
      ),
      precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          'assets/img/lemonsHome.svg',
        ),
        null,
      ),
    ]);
    setState(() => _assetsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_assetsLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final appUser = ref.watch(authProvider);
    final bool isLoading = appUser is AsyncLoading;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
              // context.push('/notificaciones');
              break;
            case 2:
              context.push('/perfil');
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1.2,
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
                    Text(
                      '¡Aloha ${appUser.asData!.value!.name.capitalize()}!',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
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
              // Mis archivos y Talleres
              Positioned(
                top: MediaQuery.of(context).size.height * 0.30,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Row(
                  children: [
                    Hero(
                      tag: 'homebutton-mis-archivos',
                      child: HomeButton(
                        imagePath: 'assets/img/ae36775c8e0c536b6c134e271841777229e6210a.png',
                        text: 'Mis archivos',
                        onPressed: () => context.push('/descargas'),
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Hero(
                      tag: 'homebutton-talleres',
                      child: HomeButton(
                        imagePath: 'assets/img/ee19a2bb0ba198a476f373bb3ee3f9e64b995714.png',
                        text: 'Talleres',
                        onPressed: () => context.push('/publicidades'),
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              // Calendario y Recomendaciones
              Positioned(
                top: MediaQuery.of(context).size.height * 0.50,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Row(
                  children: [
                    Hero(
                      tag: 'homebutton-calendario',
                      child: HomeButton(
                        imagePath: 'assets/img/084fb2c3881361e7e5ce3fb5463622843c33bf3b.png',
                        text: 'Calendario',
                        onPressed: () => context.push('/calendario'),
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Hero(
                      tag: 'homebutton-recomendaciones',
                      child: HomeButton(
                        imagePath: 'assets/img/602f21c7b3661d6df85fe352c44a38d0007ad10b.png',
                        text: 'Recomendaciones',
                        onPressed: () => context.push('/listasInteres'),
                        width: MediaQuery.of(context).size.width * 0.35,
                        imageHeight: MediaQuery.of(context).size.height * 0.11,
                        baseHeight: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
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
            url: 'https://api.whatsapp.com/send?phone=5491167999237&text=Hola%20Flor!%20Me%20interesa%20m%C3%A1s%20informaci%C3%B3n!',
            iconImage: 'assets/img/whatsapp.svg',
            iconSize: 35,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}