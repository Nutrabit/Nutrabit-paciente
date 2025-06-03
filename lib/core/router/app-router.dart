import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:nutrabit_paciente/presentations/screens/amIPatient.dart';
import 'package:nutrabit_paciente/presentations/screens/courses/course_list_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/files/download_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/files/archivos.dart';
import 'package:nutrabit_paciente/presentations/screens/files/detalleArchivo.dart';
import 'package:nutrabit_paciente/presentations/screens/files/subirArchivos.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/calendar.dart';
import 'package:nutrabit_paciente/presentations/screens/calendar/patient_calendarDay.dart';
import 'package:nutrabit_paciente/presentations/screens/home.dart';
import 'package:nutrabit_paciente/presentations/screens/homeOffline.dart';
import 'package:nutrabit_paciente/presentations/screens/login.dart';
import 'package:nutrabit_paciente/presentations/screens/notifications/detalleNotificacion.dart';
import 'package:nutrabit_paciente/presentations/screens/notifications/notificaciones.dart';
import 'package:nutrabit_paciente/presentations/screens/password/change_password.dart';
import 'package:nutrabit_paciente/presentations/screens/password/forgot_password.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_detail.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/profile_dynamic_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/select_goal_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/appointments/appointments.dart';
import 'package:nutrabit_paciente/presentations/screens/welcome/welcomeCarousel.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/patient_modifier.dart';
import 'package:nutrabit_paciente/presentations/screens/Shipments/upload_screen.dart';
import 'package:nutrabit_paciente/presentations/screens/profile/validation_profile/confirmation_aloha_comunite_screen.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/user_provider.dart';
import 'package:nutrabit_paciente/core/services/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final SharedPreferencesService sharedPreferencesService =
      SharedPreferencesService();
      final seenWelcomeState = ref.read(welcomeSessionProvider);
  
  return GoRouter(
    initialLocation: '/welcome',

    redirect: (context, state) async {
      if (authState.isLoading) return null;

      final loggedIn = authState.asData?.value != null;
      final loc = state.uri.toString();
      final isWelcome = loc == '/welcome';
      final isAmIPatient = loc == '/soyPaciente';
      final isLogin = loc == '/login';
      final isNotPatient = loc == '/homeOffline';
      final isSplash = loc == '/splash';
      final seenWelcome = seenWelcomeState;
      final dontShowWelcome = await sharedPreferencesService.getdontShowAgain();

      // Aquí ya no mutas el estado, solo decides rutas

      if (!loggedIn && dontShowWelcome == false) {
        if (isWelcome || isAmIPatient || isLogin || isNotPatient) return null;
        return '/welcome';
      } else if (!loggedIn && dontShowWelcome == true) {
        if (isAmIPatient || isLogin || isNotPatient) return null;
        return '/soyPaciente';
      }

      if (loggedIn && seenWelcome == true && dontShowWelcome == false && isWelcome) {
        if(authState.value?.createdAt == authState.value?.modifiedAt){
          return '/login/validation';
        } else {
          return '/';
        }
      }

      if (loggedIn && dontShowWelcome == false && (isAmIPatient || isLogin)) {
        return '/splash';
      } else if (loggedIn && dontShowWelcome == true && (isWelcome || isAmIPatient || isLogin)) {
        return '/splash';
      } 

      if (loggedIn && isSplash) {
        if(authState.value?.createdAt == authState.value?.modifiedAt){
          return '/login/validation';
        } else {
          return '/';
        }
      }

      return null;
    },

    routes: [
      GoRoute(path: '/welcome', builder: (context, state) => WelcomeCarousel()),
      GoRoute(path: '/', builder: (context, state) => Home()),
      GoRoute(path: '/homeOffline', builder: (context, state) => HomeOffline()),
      GoRoute(
        path: '/descargas',
        builder: (context, state) => DownloadScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => Login(),
        routes: [
          GoRoute(
            path: 'validation',
            builder: (context, state) => ProfileDynamicScreen(),
            routes: [
              GoRoute(
                path: 'select_goal',
                builder: (context, state) => SelectGoalScreen(),
                routes: [
                  GoRoute(
                    path: 'confirmation',
                    builder: (context, state) => ConfirmationScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/soyPaciente', builder: (context, state) => AmIPatient()),
      GoRoute(
        path: '/perfil',
        builder: (context, state) => PatientDetail(id: 'id'),
        routes: [
          GoRoute(path: 'turnos', builder: (context, state) => Appointments()),
          GoRoute(
            path: 'modificar',
            builder:
                (context, state) => PatientModifier(id: state.extra as String),
          ),
        ],
      ),
      GoRoute(
        path: '/archivos',
        builder: (context, state) => Archivos(),
        routes: [
          GoRoute(path: 'subir', builder: (context, state) => SubirArchivos()),
          GoRoute(
            path: ':id',
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
              final fecha =
                  state.extra
                      as DateTime; // 👈 Recibimos el DateTime correctamente
              return CalendarDayPatient(date: fecha);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/notificaciones',
        builder: (context, state) => Notificaciones(),
        routes: [
          GoRoute(
            path: ':id',
            builder:
                (context, state) => DetalleNotificacion(
                  id: state.pathParameters['id'] as String,
                ),
          ),
        ],
      ),
      GoRoute(
        path: '/envios',
        builder: (context, state) => UploadScreen(initialDate: state.extra as DateTime),
      ),
      GoRoute(
        path: '/cursos',
        builder: (context, state) => CourseListScreen(),
      ),
      GoRoute(
        path: '/recuperar-clave',
        builder: (context, state) => ForgotPassword(),
      ),
      GoRoute(
        path: '/cambiar-clave',
        builder: (context, state) => ChangePassword(),
      ),
      GoRoute(
        path: '/splash',
        builder:
            (_, __) => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      ),
    ],
  );
});
