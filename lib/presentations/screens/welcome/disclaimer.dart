import 'package:flutter/material.dart';
import 'package:nutrabit_paciente/core/services/shared_preferences.dart';

class Disclaimer extends StatefulWidget {
  const Disclaimer({super.key});

  @override
  State<Disclaimer> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _loadDontShowAgain();
  }

  Future<void> _loadDontShowAgain() async {
    final result = await _sharedPreferencesService.getdontShowAgain();
    setState(() {
      _isSelected = (result is bool) ? result : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 96, 122, 1),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child:
          
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.8,
                left: MediaQuery.of(context).size.width * 0.49,

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('No volver a mostrar'),
                    const SizedBox(width: 0.01),
                    Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: _isSelected,
                      onChanged:
                          (v) => setState(() {
                            _isSelected = v!;
                            _sharedPreferencesService.dontShowAgain(
                              _isSelected,
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    '¡Atención!',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.09,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Esta app no busca reemplazar tu consulta con un profesional de la salud. Busca poder acompañarte y motivarte para que logres generar hábitos de bienestar y salud, abarcando diversas áreas: alimento, movimiento, descanso adecuado y gestión del estrés.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.w300,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Image(image: AssetImage('assets/img/nutriaAbrazo.png')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
