import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/core/models/goal_model.dart';
import 'package:nutrabit_paciente/core/services/push_notification_service.dart';
import 'package:nutrabit_paciente/presentations/providers/auth_provider.dart';
import '../../../providers/user_provider.dart';

class SelectGoalScreen extends ConsumerStatefulWidget {
  const SelectGoalScreen({super.key});

  @override
  ConsumerState<SelectGoalScreen> createState() => _SelectGoalScreenState();
}

class _SelectGoalScreenState extends ConsumerState<SelectGoalScreen> {
  final isMobile = !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _handleGoalSelection(GoalModel goal) async {
    try {
      await ref.read(userProvider.notifier).updateFields({'goal': goal.description});
      // Esto hace que authProvider vuelva a cargar el usuario actualizado
      ref.invalidate(authProvider);
      if (isMobile) await PushNotificationService.subscribeToGoalNotification(goal);
      if (!mounted) return;
      context.go('/login/validation/select_goal/confirmation');
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstFourGoals = GoalModel.values.sublist(0, 4);
    final lastGoal = GoalModel.values.last;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          '¿Cuál es tu objetivo?',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const StepIndicator(currentStep: 1),
            const SizedBox(height: 0),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 20) / 2;

                  return Column(
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            firstFourGoals.map((goal) {
                              return SizedBox(
                                width: itemWidth,
                                height: 190,
                                child: GoalCard(
                                  goal: goal,
                                  onTap: () => _handleGoalSelection(goal),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: GoalCard(
                          goal: lastGoal,
                          onTap: () => _handleGoalSelection(lastGoal),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({this.totalSteps = 2, this.currentStep = 0, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color:
                  isActive ? const Color(0xFFD87B91) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final VoidCallback onTap;

  const GoalCard({required this.goal, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        overlayColor: WidgetStateProperty.all(
          const Color.fromARGB(13, 0, 0, 0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  goal.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                goal.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
