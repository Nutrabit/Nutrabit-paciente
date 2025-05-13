import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool?> login(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      String uid = credential.user!.uid;

      return await isPatient(uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<bool?> isPatient(String uid) async {
    try {
      final doc = await db.collection("users").doc(uid).get();
       if (doc.exists) {
        return doc.data()?['isActive'];
       }
    } catch (e) {
      print("Error al verificar patient: $e");
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("Error al hacer logout: $e");
      return false;
    }
  }
}
