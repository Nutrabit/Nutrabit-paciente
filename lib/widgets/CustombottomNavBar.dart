import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/goal_model.dart';
import 'package:nutrabit_paciente/core/services/shared_preferences.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import 'package:nutrabit_paciente/presentations/providers/notification_provider.dart';

class CustomBottomAppBar extends ConsumerStatefulWidget {
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
  ConsumerState<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends ConsumerState<CustomBottomAppBar> {
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => getNotificationsCount(),
    );
  }

  @override
  void didUpdateWidget(CustomBottomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    getNotificationsCount();
  }

  String getGoalEnum(String description) {
    for (final g in GoalModel.values) {
      if (g.description == description) {
        return g.name;
      }
    }
    return 'ALL';
  }

  Future<void> getNotificationsCount() async {
    final sp = SharedPreferencesService();
    final ns = NotificationService();
    final user = ref.read(authProvider).value;
    if (user is AsyncLoading) return;
    final _lastSeenNotf = await sp.getLastSeenNotifications();
    final _count = await ns.getUserNotificationsCount(
      userId: user!.id,
      topic: getGoalEnum(user.goal),
      lastSeenNotf: _lastSeenNotf,
    );
    setState(() {
      this.notificationCount = _count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: widget.backgroundColor,
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.icons.length, (index) {
          final iconColor =
              index == widget.currentIndex
                  ? widget.selectedItemColor
                  : widget.unselectedItemColor;

          Widget icon = Icon(widget.icons[index], color: iconColor);

          // Mostrar badge solo en ícono de notificaciones (index == 1)
          if (index == 1 && notificationCount > 0) {
            icon = Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(widget.icons[index], color: iconColor),
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }

          return Material(
            color: Colors.transparent,
            child: IconButton(
              icon: icon,
              onPressed: () => widget.onItemSelected(index),
            ),
          );
        }),
      ),
    );
  }
}
