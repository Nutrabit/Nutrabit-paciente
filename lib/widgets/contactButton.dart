import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';


class UrlFloatingActionButton extends StatelessWidget {
  
  final String url;
  final String  iconImage;
  final double iconSize;

  const UrlFloatingActionButton({
    Key? key,
    required this.url,
    required this.iconImage,
    this.iconSize = 30.0,
  }) : super(key: key);

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      // Aquí podrías mostrar un Snackbar o diálogo de error
      throw 'No se pudo abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _launchUrl,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), 
          bottomLeft: Radius.circular(30), 
          topRight: Radius.circular(30), 
          bottomRight: Radius.circular(30)),
        
      ),
      child: Positioned(
        bottom: 5,
        left: 5,

        child: SvgPicture.asset(
        iconImage,
        width: iconSize,
        height: iconSize,
        
      ),),
      
    );
  }
}
