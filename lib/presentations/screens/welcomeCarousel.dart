import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nutrabit_paciente/widgets/welcome/welcome.dart';
import 'package:nutrabit_paciente/widgets/welcome/reminder.dart';
import 'package:nutrabit_paciente/widgets/welcome/disclaimer.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeCarousel extends ConsumerStatefulWidget {
  const WelcomeCarousel({super.key});

  @override
  ConsumerState<WelcomeCarousel> createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends ConsumerState<WelcomeCarousel> {
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


    final appUser = ref.watch(authProvider);
    final bool isLoading = appUser is AsyncLoading;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Stack(
      children: [
        PageView(
          controller: _controller,
          children: _pages,
          
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.1,
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