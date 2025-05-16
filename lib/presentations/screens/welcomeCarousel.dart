import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nutrabit_paciente/widgets/welcome/welcome.dart';
import 'package:nutrabit_paciente/widgets/welcome/reminder.dart';
import 'package:nutrabit_paciente/widgets/welcome/disclaimer.dart';

class WelcomeCarousel extends StatefulWidget {
  const WelcomeCarousel({super.key});

  @override
  State<WelcomeCarousel> createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends State<WelcomeCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Widget> _pages = const [
    Welcome(),
    Reminder(),
    Disclaimer(),
  ];

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (_currentPage < _pages.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _goToLogin();
      }
    });
  }

  void _goToLogin() {
    _timer?.cancel();
    context.go('/soyPaciente');
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

    _controller.addListener(() {
      final newPage = _controller.page?.round();
      if (newPage != null && newPage != _currentPage) {
        setState(() => _currentPage = newPage);
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _controller,
          children: _pages,
        ),
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: const WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.black,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
              // Botón "Saltar"
              TextButton(
                onPressed: _goToLogin,
                child: const Text(
                  'Saltar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}