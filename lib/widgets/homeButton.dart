import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  
  final double width;
  final double imageHeight;
  final double baseHeight;

  
  final Color baseColor;
  final Color textColor;
  final double borderRadius;

  const HomeButton({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onPressed,
    this.width = 100,
    this.imageHeight = 100,
    this.baseHeight = 40,
    this.baseColor = const Color(0xFFDC607A),
    this.textColor = const Color(0xFFFFFEFE),
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: const Color(0xFFDC607A),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: const BorderSide(
          
          color: Color(0xFFDC607A),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
            child: Image.asset(
              imagePath,
              width: width,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),

          
          Container(
            width: width,
            height: baseHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(borderRadius),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
