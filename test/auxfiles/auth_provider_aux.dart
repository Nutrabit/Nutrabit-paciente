import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<AppUser?> {
  final FirebaseAuth auth;
  final FirebaseFirestore db;

  AuthNotifier({
    FirebaseAuth? authInstance,
    FirebaseFirestore? firestoreInstance,
  })  : auth = authInstance ?? FirebaseAuth.instance,
        db = firestoreInstance ?? FirebaseFirestore.instance;

  @override
  FutureOr<AppUser?> build() async {
    final firebaseUser = auth.currentUser;
    if (firebaseUser == null) return null;

    final doc = await db.collection("users").doc(firebaseUser.uid).get();
    if (!doc.exists) return null;

    final user = AppUser.fromFirestore(doc);
    return user.isActive ? user : null;
  }

  Future<bool?> login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final doc = await db.collection("users").doc(uid).get();

      if (!doc.exists) return false;

      final user = AppUser.fromFirestore(doc);
      if (user.isActive) {
        state = AsyncData(user);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print("Error de login: ${e.code}");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await auth.signOut();
      state = AsyncData(null);
      return true;
    } catch (e) {
      print("Error al hacer logout: $e");
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    try {
      if (await isPacienteByEmail(email)) {
        await auth.sendPasswordResetEmail(email: email.trim());
        state = const AsyncData(null);
      } else {
        throw FirebaseAuthException(
          code: 'not-patient',
          message: 'El email no está registrado como paciente.',
        );
      }
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<bool> isPacienteByEmail(String email) async {
    try {
      final snapshot = await db
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error al verificar paciente por email: $e");
      return false;
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String repeatPassword,
  }) async {
    state = const AsyncLoading();
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No hay ningún usuario autenticado.',
        );
      } else if (newPassword.length < 6) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'La nueva contraseña debe tener mínimo 6 caracteres.',
        );
      } else if (currentPassword == newPassword) {
        throw FirebaseAuthException(
          code: 'same-password',
          message: 'La nueva contraseña no puede ser igual a la actual.',
        );
      } else if (newPassword != repeatPassword) {
        throw FirebaseAuthException(
          code: 'password-mismatch',
          message: 'Las contraseñas no coinciden.',
        );
      } else {
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword.trim(),
        );
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword.trim());
        state = const AsyncData(null);
        logout();
      }
    } on FirebaseAuthException catch (e, st) {
      String message;
      switch (e.code) {
        case 'invalid-credential':
          message = 'La contraseña actual es incorrecta.';
          break;
        default:
          message = e.message ?? 'Error desconocido: ${e.code}';
      }
      state = AsyncError(
        FirebaseAuthException(code: e.code, message: message),
        st,
      );
    }
  }
}
