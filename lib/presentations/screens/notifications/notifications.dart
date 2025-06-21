import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';
import 'package:nutrabit_paciente/core/models/goal_model.dart';
import 'package:nutrabit_paciente/core/models/notification_model.dart';
import 'package:nutrabit_paciente/core/services/shared_preferences.dart';
import 'package:nutrabit_paciente/presentations/providers/notification_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/user_provider.dart';
import 'package:nutrabit_paciente/widgets/CustombottomNavBar.dart';

class Notifications extends ConsumerStatefulWidget {
  const Notifications({super.key});

  @override
  ConsumerState<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<Notifications> {
  DateTime? lastSeenNotf;
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  bool _initialized = false;

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  String getGoalEnum(String description) {
    GoalModel goal = GoalModel.values.firstWhere(
      (g) => g.description == description,
    );
    return goal.name;
  }

  Future<void> _loadLastSeenAndPrepareNotifications(AppUser user) async {
    final sp = SharedPreferencesService();
    final _lastSeenNotf = await sp.getLastSeenNotifications();
    if (!mounted) return;

    final fetchedNotifications = await NotificationService().getUserNotifications(
      topic: getGoalEnum(user.goal),
      userId: user.id,
      lastSeenNotf: _lastSeenNotf,
    );

    if (!mounted) return;
    setState(() {
      lastSeenNotf = _lastSeenNotf;
      notifications = fetchedNotifications;
      isLoading = false;
    });

    await sp.setLastSeenNotifications(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

  if (!_initialized && user != null) {
    _initialized = true;
    Future.microtask(() => _loadLastSeenAndPrepareNotifications(user));
  }

  if (user == null || isLoading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        currentIndex: 1,
        onItemSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              break;
            case 2:
              context.go('/perfil');
              break;
          }
        },
      ),
      backgroundColor: const Color(0xFFFEECDA),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/img/RectangleLila.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/img/bear.png',
              width: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          if (notifications.isEmpty)
            const Center(child: Text('No hay notificaciones pendientes.'))
          else
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null &&
                        details.primaryVelocity! < 0) {
                      removeNotification(index);
                    }
                  },
                  child: NotificationCard(
                    title: notif.title,
                    description: notif.description,
                    scheduledTime: notif.scheduledTime,
                    onTap: () => removeNotification(index),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

String timeAgo(DateTime date) {
  final Duration diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) return 'hace ${diff.inSeconds} segundos';
  if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} minutos';
  if (diff.inHours < 24) return 'hace ${diff.inHours} horas';
  if (diff.inDays < 7) return 'hace ${diff.inDays} días';
  if (diff.inDays < 30) return 'hace ${diff.inDays ~/ 7} semanas';
  if (diff.inDays < 365) return 'hace ${diff.inDays ~/ 30} meses';
  return 'hace ${diff.inDays ~/ 365} años';
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime scheduledTime;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeText = timeAgo(scheduledTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9F7D6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    timeText,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
