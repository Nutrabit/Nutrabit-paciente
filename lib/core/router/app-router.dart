import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/screens/files/archivos.dart';
import 'package:nutrabit_paciente/presentations/screens/files/detalleArchivo.dart';
import 'package:nutrabit_paciente/presentations/screens/files/subirArchivos.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/calendario.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/detalleDiaCalendario.dart';
import 'package:nutrabit_paciente/presentations/screens/home.dart';
import 'package:nutrabit_paciente/presentations/screens/interest_list/listaInteres.dart';
import 'package:nutrabit_paciente/presentations/screens/login.dart';
import 'package:nutrabit_paciente/presentations/screens/notifications/detalleNotificacion.dart';
import 'package:nutrabit_paciente/presentations/screens/notifications/notificaciones.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_detail.dart';
import 'package:nutrabit_paciente/presentations/screens/publicity/detallePublicidad.dart';
import 'package:nutrabit_paciente/presentations/screens/publicity/publicidades.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/turnos/turnos.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Home()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => PatientDetail(),
      routes: [
        GoRoute(
          path: '/turnos', 
          builder: (context, state) => Turnos()
          )],
    ),
    GoRoute(
      path: '/archivos',
      builder: (context, state) => Archivos(),
      routes: [
        GoRoute(path: '/subir', builder: (context, state) => SubirArchivos()),
        GoRoute(path: '/:id', builder: (context, state) => DetalleArchivo(id: state.pathParameters['id'] as String)),
      ],
    ),
    GoRoute(
      path: '/calendario',
      builder: (context, state) => Calendario(),
      routes: [
        GoRoute(
          path: '/:fecha',
          builder: (context, state) => DetalleDiaCalendario( fecha: state.pathParameters['fecha'] as String,),
        ),
      ],
    ),
    GoRoute(
      path: '/publicidades',
      builder: (context, state) => Publicidades(),
      routes: [
        GoRoute(
          path: '/:id',
          builder:(context, state) => DetallePublicidad(id: state.pathParameters['id'] as String),
        ),
      ],
    ),
    GoRoute(
      path: '/notificaciones',
      builder: (context, state) => Notificaciones(),
      routes: [
        GoRoute(
          path: '/:id',
          builder:(context, state) => DetalleNotificacion(id: state.pathParameters['id'] as String),
        ),
      ],
    ),
    GoRoute(
      path: '/listasInteres',
      builder: (context, state) => ListaInteres(),
    ),
  ],
);
