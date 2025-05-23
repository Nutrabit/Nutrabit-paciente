import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../auxfiles/auth_provider_aux.dart';
import 'package:nutrabit_paciente/core/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_provider_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  UserCredential,
  User,
  Query,
  DocumentSnapshot<Map<String, dynamic>>,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
])
MockQuerySnapshot<Map<String, dynamic>> createMockQuerySnapshotWithDocs() {
  final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
  final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();

  when(mockDoc.data()).thenReturn({'email': 'email@test.com'});
  when(mockSnapshot.docs).thenReturn([mockDoc]);

  return mockSnapshot;
}

MockQuerySnapshot<Map<String, dynamic>> createMockQuerySnapshotWithoutDocs() {
  final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
  when(mockSnapshot.docs).thenReturn([]);

  return mockSnapshot;
}

class SpyAuthNotifier extends AuthNotifier {
  SpyAuthNotifier({
    required super.authInstance,
    required super.firestoreInstance,
  });
}

final testAuthProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(
  () => throw UnimplementedError(), // lo overrideamos en los tests
);

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;

  late ProviderContainer container;
  late AuthNotifier authNotifier;

  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockQueryDocSnapshot;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();

    container = ProviderContainer(
      overrides: [
        // 👈 agregado
        authProvider.overrideWith(
          () => AuthNotifier(
            authInstance: mockAuth,
            firestoreInstance: mockFirestore,
          ),
        ),
      ],
    );

    authNotifier = container.read(authProvider.notifier);

    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocRef = MockDocumentReference<Map<String, dynamic>>();
    mockDocSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQueryDocSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

    when(mockFirestore.collection('users')).thenReturn(mockCollection);
    when(
      mockCollection.where('email', isEqualTo: 'email@test.com'),
    ).thenReturn(mockQuery);
    when(mockQuery.limit(1)).thenReturn(mockQuery);
    when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
    when(mockQueryDocSnapshot.exists).thenReturn(true);
    when(
      mockQueryDocSnapshot.data(),
    ).thenReturn({'email': 'email@test.com', 'role': 'paciente'});
  });

  tearDown(() {
    container.dispose(); // 👈 agregado
  });

  group('AuthNotifier tests', () {
    test('build returns AppUser if user is logged in and active', () async {
      final mockUser = MockUser();

      // Mockeamos que el usuario está logueado y tiene un UID
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid123');

      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(mockCollection.doc('uid123')).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

      // Simulamos que el documento existe y el usuario está activo
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn({'isActive': true});
      when(mockDocSnapshot.id).thenReturn('uid123');

      // Simulamos que el método AppUser.fromFirestore devuelva un usuario activo
      // Puedes crear un fake aquí si no puedes mockear el método estático
      when(mockDocSnapshot.data()).thenReturn({
        'dni': '12345678',
        'name': 'Juan',
        'lastname': 'Pérez',
        'email': 'juan.perez@example.com',
        'birthday': Timestamp.fromDate(DateTime(1990, 5, 15)),
        'height': 180,
        'weight': 75,
        'gender': 'Masculino',
        'isActive': true,
        'profilePic': 'path_to_profile_pic',
        'goal': 'Bajar de peso',
        'events': [], // lista vacía
        'appointments': [], // lista vacía
        'createdAt': null,
        'modifiedAt': null,
        'deletedAt': null,
      });
      when(mockDocSnapshot.id).thenReturn('uid123');
      // Supongamos que authNotifier.build() devuelva el fakeUser
      // Simulamos que la respuesta no es null
      final result = await authNotifier.build();

      // Aquí deberías verificar que el resultado sea un AppUser y no nulo
      expect(
        result,
        isNotNull,
      ); // Cambié a isNotNull porque el usuario debería existir
      expect(result, isA<AppUser>());
    });

    group('login', () {
      test('successful login sets state and returns true', () async {
        final container = ProviderContainer(
          overrides: [
            authProvider.overrideWith(
              () => AuthNotifier(
                authInstance: mockAuth,
                firestoreInstance: mockFirestore,
              ),
            ),
          ],
        );

        final authNotifier = container.read(authProvider.notifier);

        final mockUser = MockUser();
        final mockUserCredential = MockUserCredential();

        // Mockeamos el login exitoso
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('uid123');
        when(
          mockAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('uid123')).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn({
          'dni': '12345678',
          'name': 'Juan',
          'lastname': 'Pérez',
          'email': 'juan.perez@example.com',
          'birthday': Timestamp.fromDate(DateTime(1990, 5, 15)),
          'height': 180,
          'weight': 75,
          'gender': 'Masculino',
          'isActive': true,
          'profilePic': 'path_to_profile_pic',
          'goal': 'Bajar de peso',
          'events': [],
          'appointments': [],
          'createdAt': null,
          'modifiedAt': null,
          'deletedAt': null,
        });
        when(mockDocSnapshot.id).thenReturn('uid123');

        final result = await authNotifier.login(
          'email@test.com',
          'password123',
        );

        // Verificamos que el login sea exitoso
        expect(result, true);

        // El estado es AsyncData<AppUser?> porque AppUser es nullable
        expect(authNotifier.state, isA<AsyncData<AppUser?>>());

        // Verificamos que el valor interno no sea nulo y sea un AppUser válido
        final user = authNotifier.state.value;
        expect(user, isNotNull);
        expect(user, isA<AppUser>());

        container.dispose();
      });

      test('login returns false if user doc does not exist', () async {
        final mockUser = MockUser();
        final mockUserCredential = MockUserCredential();

        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('uid123');
        when(
          mockAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('uid123')).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);

        when(mockDocSnapshot.exists).thenReturn(false);

        final result = await authNotifier.login(
          'email@test.com',
          'password123',
        );

        expect(result, false);
      });

      test('login returns false on FirebaseAuthException', () async {
        when(
          mockAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        final result = await authNotifier.login(
          'email@test.com',
          'password123',
        );

        expect(result, false);
      });
    });
  });
  group('logout', () {
    test('logout signs out and sets state to null', () async {
      final mockAuth = MockFirebaseAuth();
      final mockFirestore = MockFirebaseFirestore(); // si lo necesitas

      when(mockAuth.signOut()).thenAnswer((_) async => null);

      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(
            () => AuthNotifier(
              authInstance: mockAuth,
              firestoreInstance: mockFirestore,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final authNotifier = container.read(authProvider.notifier);

      final result = await authNotifier.logout();

      expect(result, true);
      expect(authNotifier.state, isA<AsyncData<AppUser?>>());
      expect(authNotifier.state.value, null);
    });

    test('logout returns false on exception', () async {
      when(mockAuth.signOut()).thenThrow(Exception('Sign out failed'));

      final result = await authNotifier.logout();

      expect(result, false);
    });
  });

  group('sendPasswordResetEmail', () {
    test(
      'sendPasswordResetEmail succeeds when email belongs to patient',
      () async {
        final email = 'email@test.com';

        final container = ProviderContainer(
          overrides: [
            testAuthProvider.overrideWith(
              () => SpyAuthNotifier(
                authInstance: mockAuth,
                firestoreInstance: mockFirestore,
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final authNotifierSpy = container.read(testAuthProvider.notifier);

        when(
          mockAuth.sendPasswordResetEmail(email: email),
        ).thenAnswer((_) async => null);

        await authNotifierSpy.sendPasswordResetEmail(email);

        expect(authNotifierSpy.state, isA<AsyncData<AppUser?>>());
        expect(authNotifierSpy.state.value, null);
      },
    );

    test('sendPasswordResetEmail fails when email not registered', () async {
      final email = 'email@test.com';

      final container = ProviderContainer(
        overrides: [
          testAuthProvider.overrideWith(
            () => SpyAuthNotifier(
              authInstance: mockAuth,
              firestoreInstance: mockFirestore,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final authNotifierSpy = container.read(testAuthProvider.notifier);

      // 🔧 Forzar que no se encuentre el paciente en Firestore
      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(
        mockCollection.where('email', isEqualTo: email),
      ).thenReturn(mockQuery);
      when(mockQuery.limit(1)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([]); // sin documentos

      await authNotifierSpy.sendPasswordResetEmail(email);

      expect(authNotifierSpy.state, isA<AsyncError>());
      final error = authNotifierSpy.state.error as FirebaseAuthException;
      expect(error.code, 'not-patient');
    });

    test('sendPasswordResetEmail catches FirebaseAuthException', () async {
      final email = 'email@test.com';

      final container = ProviderContainer(
        overrides: [
          testAuthProvider.overrideWith(
            () => SpyAuthNotifier(
              authInstance: mockAuth,
              firestoreInstance: mockFirestore,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final authNotifierSpy = container.read(testAuthProvider.notifier);

      // ✅ Forzar que Firestore devuelva un usuario válido
      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(
        mockCollection.where('email', isEqualTo: email),
      ).thenReturn(mockQuery);
      when(mockQuery.limit(1)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);
      when(mockQueryDocSnapshot.exists).thenReturn(true);
      when(
        mockQueryDocSnapshot.data(),
      ).thenReturn({'email': email, 'role': 'paciente'});

      // ✅ Simular que Firebase Auth lanza excepción
      when(
        mockAuth.sendPasswordResetEmail(email: email),
      ).thenThrow(FirebaseAuthException(code: 'unknown-error'));

      await authNotifierSpy.sendPasswordResetEmail(email);

      expect(authNotifierSpy.state, isA<AsyncError>());
    });
  });

  group('isPacienteByEmail', () {
    test('returns true if user exists with email', () async {
      final email = 'email@test.com';

      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(
        mockCollection.where('email', isEqualTo: email.trim()),
      ).thenReturn(mockCollection);
      when(mockCollection.limit(1)).thenReturn(mockCollection);
      when(
        mockCollection.get(),
      ).thenAnswer((_) async => createMockQuerySnapshotWithDocs());

      final result = await authNotifier.isPacienteByEmail(email);

      expect(result, true);
    });

    test('returns false if no user exists with email', () async {
      final email = 'email@test.com';

      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(
        mockCollection.where('email', isEqualTo: email.trim()),
      ).thenReturn(mockCollection);
      when(mockCollection.limit(1)).thenReturn(mockCollection);
      when(
        mockCollection.get(),
      ).thenAnswer((_) async => createMockQuerySnapshotWithoutDocs());

      final result = await authNotifier.isPacienteByEmail(email);

      expect(result, false);
    });

    test('returns false on exception', () async {
      final email = 'email@test.com';

      when(mockFirestore.collection('users')).thenThrow(Exception('DB error'));

      final result = await authNotifier.isPacienteByEmail(email);

      expect(result, false);
    });
  });

  group('updatePassword', () {
    test(
      'successful password update logs out and sets state to AsyncData(null)',
      () async {
        final mockUser = MockUser();
        when(mockAuth.currentUser).thenReturn(mockUser);
        when(mockUser.email).thenReturn('email@test.com');
        when(
          mockUser.reauthenticateWithCredential(any),
        ).thenAnswer((_) async => MockUserCredential());
        when(mockUser.updatePassword(any)).thenAnswer((_) async => null);
        when(mockAuth.signOut()).thenAnswer((_) async => null);

        await authNotifier.updatePassword(
          currentPassword: 'oldPass123',
          newPassword: 'newPass123',
          repeatPassword: 'newPass123',
        );

        expect(authNotifier.state, isA<AsyncData<AppUser?>>());
        expect(authNotifier.state.value, null);
      },
    );

    test('throws error if no current user', () async {
      when(mockAuth.currentUser).thenReturn(null);

      await authNotifier.updatePassword(
        currentPassword: 'oldPass123',
        newPassword: 'newPass123',
        repeatPassword: 'newPass123',
      );

      expect(authNotifier.state, isA<AsyncError>());
      final error = authNotifier.state.error as FirebaseAuthException;
      expect(error.code, 'no-user');
    });

    test('throws error if new password less than 6 chars', () async {
      final mockUser = MockUser();
      when(mockAuth.currentUser).thenReturn(mockUser);

      await authNotifier.updatePassword(
        currentPassword: 'oldPass123',
        newPassword: '123',
        repeatPassword: '123',
      );

      expect(authNotifier.state, isA<AsyncError>());
      final error = authNotifier.state.error as FirebaseAuthException;
      expect(error.code, 'weak-password');
    });

    test('throws error if new password same as current', () async {
      final mockUser = MockUser();
      when(mockAuth.currentUser).thenReturn(mockUser);

      await authNotifier.updatePassword(
        currentPassword: 'samePass',
        newPassword: 'samePass',
        repeatPassword: 'samePass',
      );

      expect(authNotifier.state, isA<AsyncError>());
      final error = authNotifier.state.error as FirebaseAuthException;
      expect(error.code, 'same-password');
    });

    test('throws error if new passwords do not match', () async {
      final mockUser = MockUser();
      when(mockAuth.currentUser).thenReturn(mockUser);

      await authNotifier.updatePassword(
        currentPassword: 'oldPass123',
        newPassword: 'newPass123',
        repeatPassword: 'diffPass123',
      );

      expect(authNotifier.state, isA<AsyncError>());
      final error = authNotifier.state.error as FirebaseAuthException;
      expect(error.code, 'password-mismatch');
    });

    test('handles reauthentication failure with invalid-credential', () async {
      final mockUser = MockUser();
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('email@test.com');
      when(
        mockUser.reauthenticateWithCredential(any),
      ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      await authNotifier.updatePassword(
        currentPassword: 'oldPass123',
        newPassword: 'newPass123',
        repeatPassword: 'newPass123',
      );

      expect(authNotifier.state, isA<AsyncError>());
      final error = authNotifier.state.error as FirebaseAuthException;
      expect(error.code, 'invalid-credential');
      expect(error.message, 'La contraseña actual es incorrecta.');
    });
  });
}
