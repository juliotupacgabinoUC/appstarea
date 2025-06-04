import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'models/user_model.dart'; // Asegúrate que este modelo exista

class AuthService {
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;

  // Stream para escuchar cambios en el estado de autenticación
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Convertir Firebase User a nuestro UserModel
  UserModel? _userFromFirebaseUser(fb_auth.User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  // Obtener el usuario actual (sincrónico)
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebaseUser(user);
  }
  
  // Obtener el UID del usuario actual
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Registrarse con email y contraseña
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Aquí podrías querer guardar información adicional del usuario en Firestore.
      // Ejemplo: _firestoreService.setUserProfile(result.user!.uid, {'displayName': 'Nuevo Usuario'});
      return _userFromFirebaseUser(result.user);
    } on fb_auth.FirebaseAuthException catch (e) {
      // Manejar errores específicos: e.code (e.g., 'email-already-in-use', 'weak-password')
      print('Error de registro en Firebase Auth: ${e.message}');
      throw Exception('Error de registro: ${e.message}');
    } catch (e) {
      print('Error desconocido en registro: $e');
      throw Exception('Error desconocido durante el registro.');
    }
  }

  // Iniciar sesión con email y contraseña
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebaseUser(result.user);
    } on fb_auth.FirebaseAuthException catch (e) {
      // Manejar errores específicos: e.code (e.g., 'user-not-found', 'wrong-password')
      print('Error de inicio de sesión en Firebase Auth: ${e.message}');
      throw Exception('Error de inicio de sesión: ${e.message}');
    } catch (e) {
      print('Error desconocido en inicio de sesión: $e');
      throw Exception('Error desconocido durante el inicio de sesión.');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
      throw Exception('Error al cerrar sesión.');
    }
  }

  // (Opcional) Iniciar sesión como administrador (podría tener lógica adicional de verificación de roles)
  Future<UserModel?> signInAdminWithEmailAndPassword(String email, String password) async {
    // Este podría ser el mismo que signInWithEmailAndPassword,
    // pero la verificación de si es admin se haría después,
    // consultando un campo 'isAdmin' o 'role' en Firestore para ese UID.
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Aquí, después del login, verificarías el rol en Firestore.
      // Ejemplo: bool isAdmin = await _firestoreService.isAdminUser(result.user!.uid);
      // if (!isAdmin) { await signOut(); throw Exception('Acceso denegado. No es administrador.'); }
      return _userFromFirebaseUser(result.user);
    } on fb_auth.FirebaseAuthException catch (e) {
      print('Error de inicio de sesión admin en Firebase Auth: ${e.message}');
      throw Exception('Error de inicio de sesión admin: ${e.message}');
    } catch (e) {
      print('Error desconocido en inicio de sesión admin: $e');
      throw Exception('Error desconocido durante el inicio de sesión admin.');
    }
  }
}