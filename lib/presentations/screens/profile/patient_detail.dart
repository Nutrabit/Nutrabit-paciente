import 'package:flutter/material.dart';
import '/core/utils/utils.dart';
import '/presentations/providers/auth_provider.dart';
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
    final appUser = ref.watch(authProvider);

    return appUser.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
        });
        return const SizedBox.shrink();
      },
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const SizedBox.shrink();
        }
        final id = appUser.value!.id;

        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(id)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(child: Text('Paciente no encontrado')),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final name = data['name']?.toString().capitalize() ?? 'Sin nombre';
            final lastname = data['lastname']?.toString().capitalize() ?? '';
            final completeName = '$name $lastname';
            final email = data['email'] ?? '-';
            final weight = data['weight']?.toString() ?? '-';
            final height = data['height']?.toString() ?? '-';
            final diet = data['dieta'] ?? '-';
            final isActive = data['isActive'] ?? true;
            final profilePic = data['profilePic'];
            final birthdayTimestamp = data['birthday'] as Timestamp?;
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
                currentIndex: 0,
                onItemSelected: (index) {
                  switch (index) {
                    case 0:
                      context.go('/');
                      break;
                    case 1:
                      //context.go('/notificaciones');
                      break;
                    case 2:
                      context.go('/perfil');
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
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientModifier(id: id),
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
                    ElevatedButton(onPressed: () {context.go('/cambiar-clave');}, style: mainButtonDecoration(), child: const Text('Cambiar contraseña'),),
                  ],
                ),
              ),
            );
          },
        );
      },
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
                      top: MediaQuery.of(context).size.height * 0.001,
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
                                diet,
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
