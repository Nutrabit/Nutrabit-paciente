import 'package:flutter/material.dart';


class CustomBottomAppBar extends StatelessWidget {
 
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  
  final List<IconData> icons; 
  final Color backgroundColor;  
  final Color selectedItemColor;
  final Color unselectedItemColor;

  const CustomBottomAppBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
    this.icons = const [Icons.home, Icons.notifications, Icons.person],
    this.backgroundColor = const Color.fromARGB(47, 196, 196, 110),
    this.selectedItemColor = const Color(0xFFDC607A),
    this.unselectedItemColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: backgroundColor,
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          return Material(
            color: Colors.transparent,
            child:IconButton(
            icon: Icon(icons[index]),
            color: index == currentIndex
                ? selectedItemColor
                : unselectedItemColor,
            onPressed: () => onItemSelected(index),
          ),
          );
        }),
      ),
    );
  }
}