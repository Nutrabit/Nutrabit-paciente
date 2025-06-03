import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/app_user.dart';
import '../../../../core/utils/utils.dart';
import 'dart:io';

final usersProvider = FutureProvider<List<AppUser>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('users').get();

  final users = snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList()
    ..sort((a, b) => normalize(a.name).compareTo(normalize(b.name)));

  return users;
});

Future<void> addUser(AppUser user) async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  try {
    final password = generateRandomPassword();
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    final uid = userCredential.user!.uid;
    final newUser = user.copyWith(id: uid);
    await firestore.collection('users').doc(uid).set(newUser.toMap());
  } on FirebaseAuthException catch (e) {
    throw Exception('Error de autenticación: ${e.message}');
  } catch (e) {
    throw Exception('Error al agregar el usuario: $e');
  }
}

final searchUsersProvider = FutureProvider.family<List<AppUser>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];

    final firestore = FirebaseFirestore.instance;
    final usersCollection = firestore.collection('users');

    final usersByName = await usersCollection.orderBy('name').startAt([query]).endAt(['$query\uf8ff']).get();
    final usersByLastName = await usersCollection.orderBy('lastname').startAt([query]).endAt(['$query\uf8ff']).get();
    final usersByEmail = await usersCollection.orderBy('email').startAt([query]).endAt(['$query\uf8ff']).get();

    final Map<String, QueryDocumentSnapshot> usersMap = {
      for (var doc in usersByName.docs) doc.id: doc,
      for (var doc in usersByLastName.docs) doc.id: doc,
      for (var doc in usersByEmail.docs) doc.id: doc,
    };

    final users = usersMap.values.map((doc) => AppUser.fromFirestore(doc)).toList()
      ..sort((a, b) => normalize(a.name).compareTo(normalize(b.name)));

    return users;
  },
);

class UserNotifier extends StateNotifier<AppUser?> {
  UserNotifier() : super(null) {
    _loadCurrentUser();
  }

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      state = AppUser.fromFirestore(doc);
    }
  }

  Future<void> updateFields(Map<String, dynamic> changes) async {
    final currentUser = state;
    if (currentUser == null) return;

    changes['modifiedAt'] = Timestamp.fromDate(DateTime.now());

    await _firestore.collection('users').doc(currentUser.id).update(changes);

    await _loadCurrentUser();
  }

  Future<void> refreshUser() async {
    await _loadCurrentUser();
  }

  Future<void> deleteProfileImage() async {
  final currentUser = state;
  if (currentUser == null || currentUser.profilePic == null || currentUser.profilePic!.isEmpty) return;

  try {

    final ref = FirebaseStorage.instance.refFromURL(currentUser.profilePic!);
    await ref.delete();

    await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update({
      'profilePic': '',
      'modifiedAt': Timestamp.now(),
    });
    state = currentUser.copyWith(profilePic: '');
  } catch (e) {
    print('Error al eliminar la imagen de perfil: $e');
    rethrow;
  }
}

Future<void> uploadProfileImage(File imageFile) async {
    final currentUser = state;
    if (currentUser == null) return;

    try {
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${currentUser.id}-${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      await _firestore.collection('users').doc(currentUser.id).update({
        'profilePic': imageUrl,
        'modifiedAt': Timestamp.now(),
      });
      state = currentUser.copyWith(profilePic: imageUrl);
    } catch (e) {
      print('Error al subir imagen de perfil: $e');
      rethrow;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AppUser?>((ref) {
  return UserNotifier();
});


final welcomeSessionProvider = StateProvider<bool>((_) => false);