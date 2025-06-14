import 'package:flutter/material.dart';
import '/core/utils/utils.dart';
import '/presentations/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '/widgets/logout.dart';
import '/core/utils/decorations.dart';
import 'package:nutrabit_paciente/widgets/custombottomNavBar.dart';
import 'patient_modifier.dart';

class PatientDetail extends ConsumerWidget {
  final String id;

  const PatientDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(userProvider);


    if (appUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (appUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final data = appUser.toMap();
    final name = data['name']?.toString().capitalize() ?? 'Sin nombre';
    final lastname = data['lastname']?.toString().capitalize() ?? '';
    final completeName = '$name $lastname';
    final email = data['email'] ?? '-';
    final weightValue = data['weight'];
    final heightValue = data['height'];
    final weight = (weightValue == null || weightValue == 0) ? '-' : '$weightValue';
    final height = (heightValue == null || heightValue == 0) ? '-' : '$heightValue';
    final diet = data['dieta'] ?? '-';
    final profilePic = data['profilePic'];

    if (profilePic != null && profilePic is String && profilePic.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        precacheImage(NetworkImage(profilePic), context);
      });
    }

    final birthdayTimestamp = data['birthday'] as Timestamp?;
    final goal = data['goal'];
    String age = '-';

    if (birthdayTimestamp != null) {
      age = calculateAge(birthdayTimestamp.toDate()).toString();
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [Logout()],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        currentIndex: 2,
        onItemSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/notificaciones');
              break;
            case 2:
              if (GoRouterState.of(context).uri.toString() != '/perfil') {
                context.go('/perfil');
              }
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PatientInfoCard(
              name: completeName,
              email: email,
              age: age,
              weight: weight,
              height: height,
              diet: diet,
              profilePic: profilePic,
              goal: goal ?? '',
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientModifier(id: appUser.id),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Hero(
                    tag: 'turnos',
                    child: PatientActionButton(
                      title: 'Ver historial de turnos',
                      onTap: () {
                        context.push('/perfil/turnos');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {
                context.go('/cambiar-clave');
              },
              style: mainButtonDecoration(),
              child: const Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}


//Card de paciente
class PatientInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String age;
  final String weight;
  final String height;
  final String diet;
  final String? profilePic;
  final VoidCallback onEdit;
  final String goal;

  const PatientInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.age,
    required this.weight,
    required this.height,
    required this.diet,
    this.profilePic,
    required this.onEdit,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        Row(
          children: [
            SizedBox(width: 25),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 25),
                height: 200,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(236, 218, 122, 0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * -0.01,
                      right: MediaQuery.of(context).size.width * 0.001,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: onEdit,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              profilePic != null && profilePic!.isNotEmpty
                                  ? NetworkImage(profilePic!)
                                  : const AssetImage('assets/img/avatar.jpg')
                                      as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black54,
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 0.5,
                              ),
                              Text(
                                'Edad: $age',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black54,
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 0.5,
                              ),
                              Text(
                                '$weight kg / $height cm',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black54,
                                ),
                              ),
                              const Divider(
                                color: Color.fromARGB(255, 0, 0, 0),
                                thickness: 0.5,
                              ),
                              Text(
                                goal,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Botón reutilizable
class PatientActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PatientActionButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pink.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}