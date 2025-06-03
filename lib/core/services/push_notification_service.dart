import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Aca se piden permisos para iOS
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    // Acá se configura para que la app si muestre la notificacion cuando la app esta en primer plano (para iOS)
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Se inicializa flutter_local_notifications. Para Android e iOS registra el plugin para mostrar notificaciones nativas en ambos OS.
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Logica para navegar a alguna pantalla.
      },
    );

    // Crear el canal de notificación (solo en Android). Lo que hace el canal en Android es definir como se comportan las notificaciones.
    // channel es el canal que vamos a crear y con createNotificationChannel() creamos el mismo. en caso de que haya que crear otro, repetir pasos.
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Notificaciones Importantes', // nombre
      description: 'Este canal se usa para notificaciones importantes.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Esto suscribe al topico all (Siempre que se haga el build del main el  usuario ya va a estar suscrito)
    await FirebaseMessaging.instance.subscribeToTopic('all');

    // Esto escucha las notificaciones cuando la app esta en primer plano.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(message);
      }
    });

    // Esto permite que cuando se toca la notificación y la app esta cerrada o en segundo plano se pueda redirigir a una pantalla en específico.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Logica para navegar a alguna pantalla.
    });
  }


  // En pocas palabras, aca se crea la notificacion. 
  static void showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;

    if (notification == null || android == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Notificaciones Importantes',
      channelDescription: 'Este canal se usa para notificaciones importantes.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}