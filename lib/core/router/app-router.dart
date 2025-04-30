import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentaciones/screens/archivos/archivos.dart';
import 'package:nutrabit_paciente/presentaciones/screens/archivos/detalleArchivo.dart';
import 'package:nutrabit_paciente/presentaciones/screens/archivos/subirArchivos.dart';
import 'package:nutrabit_paciente/presentaciones/screens/calendario/calendario.dart';
import 'package:nutrabit_paciente/presentaciones/screens/calendario/detalleDiaCalendario.dart';
import 'package:nutrabit_paciente/presentaciones/screens/home.dart';
import 'package:nutrabit_paciente/presentaciones/screens/listaInteres/listaInteres.dart';
import 'package:nutrabit_paciente/presentaciones/screens/login.dart';
import 'package:nutrabit_paciente/presentaciones/screens/notificaciones/detalleNotificacion.dart';
import 'package:nutrabit_paciente/presentaciones/screens/notificaciones/notificaciones.dart';
import 'package:nutrabit_paciente/presentaciones/screens/perfil/perfil.dart';
import 'package:nutrabit_paciente/presentaciones/screens/publicidades/publicidades.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Home()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(path: '/perfil', builder: (context, state) => Perfil()),
    GoRoute(
      path: '/archivos',
      builder: (context, state) => Archivos(),
      routes: [
        GoRoute(path: '/subir', builder: (context, state) => SubirArchivos()),
        GoRoute(path: '/subir', builder: (context, state) => DetalleArchivo(id: state.pathParameters['id'] as String)),
      ],
    ),
    GoRoute(
      path: '/calendario',
      builder: (context, state) => Calendario(),
      routes: [
        GoRoute(
          path: '/:fecha',
          builder: (context, state) => DetalleDiaCalendario(fecha: state.pathParameters['fecha'] as String)          
        ),
      ],
    ),
    GoRoute(
      path: '/publicidades',
      builder: (context, state) => Publicidades(),    
    ),
    GoRoute(
      path: '/notificaciones',
      builder: (context, state) => Notificaciones(),    
      routes:[
        GoRoute(
          path: '/:id',
          builder: (context, state) => DetalleNotificacion(id: state.pathParameters['id'] as String),
        )
      ]
    ),
    GoRoute(
      path: '/listasInteres',
      builder: (context, state) => ListaInteres(),    
    )
  ],
);
