import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/screens/amIPatient.dart';
import 'package:nutrabit_paciente/presentations/screens/files/download_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/files/archivos.dart';
import 'package:nutrabit_paciente/presentations/screens/files/detalleArchivo.dart';
import 'package:nutrabit_paciente/presentations/screens/files/subirArchivos.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/calendar.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/calendarDayPatient.dart';
import 'package:nutrabit_paciente/presentations/screens/home.dart';
import 'package:nutrabit_paciente/presentations/screens/interest_list/listaInteres.dart';
import 'package:nutrabit_paciente/presentations/screens/login.dart';
import 'package:nutrabit_paciente/presentations/screens/notifications/detalleNotificacion.dart';
import 'package:nutrabit_paciente/presentations/screens/notifications/notificaciones.dart';
import 'package:nutrabit_paciente/presentations/screens/password/change_password.dart';
import 'package:nutrabit_paciente/presentations/screens/password/forgot_password.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_detail.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/profile_dynamic_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/select_goal_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/publicity/detallePublicidad.dart';
import 'package:nutrabit_paciente/presentations/screens/publicity/publicidades.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/turnos/turnos.dart';
import 'package:nutrabit_paciente/presentations/screens/welcomeCarousel.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_modifier.dart';

import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/confirmation_aloha_comunite_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => WelcomeCarousel()),
    GoRoute(path: '/', builder: (context, state) => Home()),
    GoRoute(path: '/descargas', builder: (context, state) => DownloadScreen()),
    GoRoute(
      path: '/login', 
      builder: (context, state) => Login(),
      routes: [
        GoRoute(
          path: 'validation',
          builder:  (context, state) => ProfileDynamicScreen(),
          routes: [
            GoRoute(
              path: 'select_goal',
              builder:  (context, state) => SelectGoalScreen(),
              routes: [
                GoRoute(path: 'confirmation', builder: (context, state) => ConfirmationScreen()),
              ]
            ),
          ],
        ),
      ]),
    GoRoute(path: '/soyPaciente', builder:(context, state) => AmIPatient()),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => PatientDetail(id: 'id'),
      routes: [
        GoRoute(
          path: 'turnos',
          builder: (context, state) => Turnos(),
        ),
        GoRoute(
          path: 'modificar',
          builder: (context, state) => PatientModifier(id: state.extra as String),
        ),
      ],
    ),

    GoRoute(
      path: '/archivos',
      builder: (context, state) => Archivos(),
      routes: [
        GoRoute(path: '/subir', builder: (context, state) => SubirArchivos()),
        GoRoute(
          path: '/:id',
          builder:
              (context, state) =>
                  DetalleArchivo(id: state.pathParameters['id'] as String),
        ),
      ],
    ),
   GoRoute(
  path: '/calendario',
  builder: (context, state) => Calendar(),
  routes: [
    GoRoute(
      path: 'detalle',
      builder: (context, state) {
        final fecha = state.extra as DateTime; // 👈 Recibimos el DateTime correctamente
        return CalendarDayPatient(fecha: fecha);
      },
    ),
  ],
),

    GoRoute(
      path: '/publicidades',
      builder: (context, state) => Publicidades(),
      routes: [
        GoRoute(
          path: '/:id',
          builder:
              (context, state) =>
                  DetallePublicidad(id: state.pathParameters['id'] as String),
        ),
      ],
    ),
    GoRoute(
      path: '/notificaciones',
      builder: (context, state) => Notificaciones(),
      routes: [
        GoRoute(
          path: '/:id',
          builder:
              (context, state) =>
                  DetalleNotificacion(id: state.pathParameters['id'] as String),
        ),
      ],
    ),
    GoRoute(
      path: '/listasInteres',
      builder: (context, state) => ListaInteres(),
    ),
    GoRoute(path: '/recuperar-clave', builder: (context, state) => ForgotPassword()),
    GoRoute(path: '/cambiar-clave', builder: (context, state) =>  ChangePassword()),
  ],
);