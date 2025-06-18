import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<AppUser?> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  FutureOr<AppUser?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) {
      return null;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      await prefs.remove('isLoggedIn');
      return null;
    }

    final doc = await db.collection("users").doc(firebaseUser.uid).get();
    if (!doc.exists) {
      await prefs.remove('isLoggedIn');
      return null;
    }

    final user = AppUser.fromFirestore(doc);
    if (!user.isActive) {
      await prefs.remove('isLoggedIn');
      return null;
    }

    return user;
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
      if (!user.isActive) return false;

      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      state = AsyncData(user);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error de login: ${e.code}");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      state = const AsyncData(null);
      return true;
    } catch (e) {
      print("Error al hacer logout: $e");
      return false;
    }
  }


}
