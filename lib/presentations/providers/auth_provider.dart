import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<AppUser?> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  FutureOr<AppUser?> build() async { 
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null; 

    final doc = await db.collection("users").doc(firebaseUser.uid).get();
    if (!doc.exists) return null;

    final user = AppUser.fromFirestore(doc);
    return user.isActive ? user : null;
  }

  Future<bool?> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      await FirebaseAuth.instance.signOut();
      state = AsyncData(null);
      return true;
    } catch (e) {
      print("Error al hacer logout: $e");
      return false;
    }
  }
}