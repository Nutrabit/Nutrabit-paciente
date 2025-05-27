import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/utils/utils.dart';
import 'package:nutrabit_paciente/widgets/contactButton.dart';
import 'package:nutrabit_paciente/widgets/homeButton.dart';
import 'package:nutrabit_paciente/widgets/custombottomNavBar.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/services/shared_preferences.dart';
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _assetsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_assetsLoaded) {
      _precacheAssets();
    }
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
      precacheImage(
        const AssetImage('assets/img/ae36775c8e0c536b6c134e271841777229e6210a.png'),
        context, 
      ),
      precacheImage(
        const AssetImage('assets/img/ee19a2bb0ba198a476f373bb3ee3f9e64b995714.png'),
        context, 
      ),
      precacheImage(
        const AssetImage('assets/img/d4fbb7df798270b5e6d5c38f4faf310cc2cdf3fa.png'),
        context, 
      ),
      precacheImage(
        const AssetImage('assets/img/084fb2c3881361e7e5ce3fb5463622843c33bf3b.png'),
        context, 
      ),
      precacheImage(
        const AssetImage('assets/img/602f21c7b3661d6df85fe352c44a38d0007ad10b.png'),
        context, 
      ),
      precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          'assets/img/instagram.svg',
        ),
        null,
      ),
      precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          'assets/img/whatsapp.svg',
        ),
        null,
      ),
    ]);
    setState(() => _assetsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

    if (!_assetsLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final appUser = ref.watch(authProvider);
    final bool isLoading = appUser is AsyncLoading;

    if (isLoading) {
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
              // context.push('/notificaciones');
              sharedPreferencesService.dontShowAgain(false);
              break;
            case 2:
              context.push('/perfil');
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight * 1.2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                'assets/img/encabezadoHome.svg',
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: screenHeight * 0.1,
                left: screenWidth * 0.06,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '¡Aloha ${appUser.asData!.value!.name.capitalize()}!',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.w500,
                          ),
                          
                        ),
                        SizedBox(height: screenHeight * 0.08),
                      ],
                    ),

                    SizedBox(width: screenWidth * 0.075),
                    SvgPicture.asset(
                      'assets/img/lemonsHome.svg',
                      width: screenWidth * 0.28,
                    ),
                  ],
                ),
              ),
              // Mis archivos y Talleres
              Positioned(
                top: screenHeight * 0.30,
                left: screenWidth * 0.1,
                child: Row(
                  children: [
                    Hero(
                      tag: 'homebutton-mis-archivos',
                      child: HomeButton(
                        imagePath:
                            'assets/img/ae36775c8e0c536b6c134e271841777229e6210a.png',
                        text: 'Mis archivos',
                        onPressed: () => context.push('/descargas'),
                        width: screenWidth * 0.35,
                        imageHeight: screenHeight * 0.11,
                        baseHeight: screenHeight * 0.05,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.1),
                    Hero(
                      tag: 'homebutton-talleres',
                      child: HomeButton(
                        imagePath:
                            'assets/img/ee19a2bb0ba198a476f373bb3ee3f9e64b995714.png',
                        text: 'Talleres',
                        onPressed: () => context.push('/publicidades'),
                        width: screenWidth * 0.35,
                        imageHeight: screenHeight * 0.11,
                        baseHeight: screenHeight * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              // Calendario y Recomendaciones
              Positioned(
                top: screenHeight * 0.50,
                left: screenWidth * 0.1,
                child: Row(
                  children: [
                    Hero(
                      tag: 'homebutton-calendario',
                      child: HomeButton(
                        imagePath:
                            'assets/img/084fb2c3881361e7e5ce3fb5463622843c33bf3b.png',
                        text: 'Calendario',
                        onPressed: () => context.push('/calendario'),
                        width: screenWidth * 0.35,
                        imageHeight: screenHeight * 0.11,
                        baseHeight: screenHeight * 0.05,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Hero(
                      tag: 'homebutton-recomendaciones',
                      child: HomeButton(
                        imagePath:
                            'assets/img/602f21c7b3661d6df85fe352c44a38d0007ad10b.png',
                        text: 'Recomendaciones',
                        onPressed: () => context.push('/listasInteres'),
                        width: screenWidth * 0.35,
                        imageHeight: screenHeight * 0.11,
                        baseHeight: screenHeight * 0.05,
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
          SizedBox(height: screenHeight * 0.02),
          UrlFloatingActionButton(
            url:
                'https://api.whatsapp.com/send?phone=5491167999237&text=Hola%20Flor!%20Me%20interesa%20m%C3%A1s%20informaci%C3%B3n!',
            iconImage: 'assets/img/whatsapp.svg',
            iconSize: 35,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
