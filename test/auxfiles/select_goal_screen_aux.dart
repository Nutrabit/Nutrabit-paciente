import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrabit_paciente/presentations/providers/user_provider.dart';

class SelectGoalScreen extends ConsumerStatefulWidget {
  const SelectGoalScreen({super.key});

  @override
  ConsumerState<SelectGoalScreen> createState() => _SelectGoalScreenState();
}

class _SelectGoalScreenState extends ConsumerState<SelectGoalScreen> {
  final List<Map<String, String>> goals = [
    {'label': 'Perder grasa', 'image': 'assets/img/perder_grasa.png'},
    {'label': 'Mantener peso', 'image': 'assets/img/mantener_peso.png'},
    {'label': 'Aumentar peso', 'image': 'assets/img/aumentar_peso.png'},
    {'label': 'Ganar músculo', 'image': 'assets/img/ganar_musculo.png'},
    {'label': 'Crear hábitos saludables', 'image': 'assets/img/habitos.png'},
  ];

  Future<void> _handleGoalSelection(String goal) async {
    try {
      await ref.read(userProvider.notifier).updateFields({'goal': goal});
      if (mounted) {
        context.go('/login/validation/select_goal/confirmation');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstFourGoals = goals.sublist(0, 4);
    final lastGoal = goals.last;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          '¿Cuál es tu objetivo?',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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

      return SingleChildScrollView(   // <--- Envuelve en scroll
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: firstFourGoals.map((goal) {
                return SizedBox(
                  width: itemWidth,
                  height: 190,
                  child: GoalCard(goal: goal, onTap: () => _handleGoalSelection(goal['label']!)),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 180,
              child: GoalCard(goal: lastGoal, onTap: () => _handleGoalSelection(lastGoal['label']!)),
            ),
          ],
        ),
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
              color: isActive ? const Color(0xFFD87B91) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final Map<String, String> goal;
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
        overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.05)),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  goal['image']!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                goal['label']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
