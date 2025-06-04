// lib/providers/auth_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart'; // Para ChangeNotifier
// import 'package:flutter/material.dart'; // Solo si necesitas Widgets, sino usa foundation.dart
import '../auth_service.dart';
import '../models/user_model.dart';
import '../firestore_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService = FirestoreService(); // O inyectarlo

  UserModel? _user; // Usuario básico de Firebase Auth (uid, email)
  UserModel? _userProfile; // Perfil completo del usuario desde Firestore (con displayName, isAdmin, etc.)
  bool _isLoadingProfile = false; // Indica si el perfil de Firestore se está cargando
  String? _errorMessage;

  late StreamSubscription<UserModel?> _userAuthSubscription;

  AppAuthProvider(this._authService) {
    // Escuchar cambios en el estado de autenticación de Firebase
    _userAuthSubscription = _authService.user.listen((firebaseUser) async {
      _user = firebaseUser; // Actualizar el usuario básico de Auth

      if (firebaseUser != null) {
        // Si hay un usuario de Auth, intentar cargar su perfil completo de Firestore
        // No establecemos isLoadingProfile aquí, _loadUserProfile lo hará.
        await _loadUserProfile(firebaseUser.uid);
      } else {
        // Si no hay usuario de Auth (logout), limpiar el perfil y el estado de carga
        _userProfile = null;
        _isLoadingProfile = false; // Asegurarse que no se quede cargando si estaba en true
        _errorMessage = null; // Limpiar errores previos
        notifyListeners(); // Notificar inmediatamente el estado de deslogueo
      }
      // No llamamos a notifyListeners() aquí si _loadUserProfile ya lo hace en su finally,
      // para evitar notificaciones dobles. _loadUserProfile notificará.
      // Si firebaseUser es null, ya notificamos arriba.
    }, onError: (error) {
      // Manejar errores del stream de autenticación si es necesario
      print("Error en el stream de autenticación: $error");
      _user = null;
      _userProfile = null;
      _isLoadingProfile = false;
      _errorMessage = "Error en el servicio de autenticación.";
      notifyListeners();
    });
  }

  // Getters
  UserModel? get currentUser => _user; // El usuario básico de Firebase Auth
  UserModel? get userProfile => _userProfile; // El perfil completo con datos de Firestore
  bool get isLoadingProfile => _isLoadingProfile;
  String? get errorMessage => _errorMessage;

  bool get isFirebaseAuthenticated => _user != null;
  bool get isAuthenticatedAndReady => _user != null && _userProfile != null && !_isLoadingProfile;
  bool get isAdmin => _userProfile?.isAdmin ?? false;

  // Getter de conveniencia solicitado
  bool get isAuthenticated => isAuthenticatedAndReady;

  // Expone el stream del usuario básico de Auth si es necesario
  Stream<UserModel?> get userAuthStream => _authService.user;


  Future<void> _loadUserProfile(String uid) async {
    if (_isLoadingProfile && _userProfile?.uid == uid) return; // Evitar recargas si ya está cargando el mismo perfil

    _isLoadingProfile = true;
    notifyListeners(); // Notificar que la carga del perfil ha comenzado

    try {
      final profile = await _firestoreService.getUserProfile(uid);
      // Solo actualizar si el usuario de auth sigue siendo el mismo
      // Esto evita una condición de carrera si el usuario se desloguea mientras el perfil carga
      if (_user?.uid == uid) {
        _userProfile = profile;
        _errorMessage = null;
      } else {
        // El usuario cambió durante la carga del perfil, no actualizar.
        // El listener de userAuthStream se encargará de limpiar _userProfile si _user es null.
        _userProfile = null; // Asegurar limpieza si el usuario ya no coincide
      }
    } catch (e) {
      print("Error cargando perfil de usuario ($uid): $e");
      if (_user?.uid == uid) { // Solo mostrar error si aún aplica al usuario actual
        _errorMessage = "No se pudo cargar el perfil del usuario.";
        _userProfile = null;
      }
    } finally {
      // Solo cambiar isLoadingProfile si la carga era para el usuario actual
      if (_user?.uid == uid || _user == null) { // O si el usuario ya se deslogueó
         _isLoadingProfile = false;
      }
      notifyListeners(); // Notificar que la carga del perfil ha terminado (con éxito o error)
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    _isLoadingProfile = true; // Indica que un proceso de autenticación/perfil está en marcha
    _errorMessage = null;
    notifyListeners();

    try {
      UserModel? newUserAuth = await _authService.signUpWithEmailAndPassword(email, password);
      if (newUserAuth != null) {
        // _user se actualiza por el listener de userAuthStream.
        // Creamos y guardamos el perfil inicial en Firestore.
        UserModel initialProfile = UserModel(
          uid: newUserAuth.uid,
          email: email,
          displayName: displayName,
          isAdmin: false, // Por defecto, los nuevos usuarios no son administradores
        );
        await _firestoreService.setUserProfile(newUserAuth.uid, initialProfile.toMap());
        // Actualizar el perfil local inmediatamente y notificar.
        // _loadUserProfile podría ser llamado por el listener, pero aquí ya tenemos los datos.
        _userProfile = initialProfile;
        _errorMessage = null;
        _isLoadingProfile = false; // Terminó la carga del perfil (porque lo creamos)
        notifyListeners();
        return true;
      }
      // Si newUserAuth es null (raro si no hay excepción)
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoadingProfile = true; // El listener llamará a _loadUserProfile que maneja este flag
    _errorMessage = null;
    notifyListeners(); // Notificar que el proceso de login ha comenzado

    try {
      UserModel? signedInUserAuth = await _authService.signInWithEmailAndPassword(email, password);
      // Si el login de Firebase Auth es exitoso, signedInUserAuth no será null.
      // El listener de _authService.user se activará, actualizará _user y llamará a _loadUserProfile.
      // _isLoadingProfile será manejado por _loadUserProfile.
      // Si hay una excepción, el bloque catch la manejará.
      return signedInUserAuth != null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _isLoadingProfile = false; // Asegurarse de resetear en caso de error de login en Auth
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signInAdmin(String email, String password) async {
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserModel? signedInUserAuth = await _authService.signInWithEmailAndPassword(email, password);
      if (signedInUserAuth != null) {
        // El listener de userAuthStream llamará a _loadUserProfile.
        // Aquí esperamos a que _loadUserProfile complete su trabajo para este usuario.
        // Esto es necesario porque necesitamos verificar el rol 'isAdmin' inmediatamente.
        await _loadUserProfile(signedInUserAuth.uid);

        if (_userProfile == null) { // Si _loadUserProfile falló o el usuario ya no coincide
          _errorMessage = "No se pudo verificar el perfil del administrador.";
           // Si _userProfile es null, isAdmin será false, y el siguiente if lo manejará
           // o si _user ya no coincide (logout rápido), el listener ya habrá limpiado.
        }

        if (!isAdmin) { // isAdmin usa _userProfile
          await _authService.signOut(); // Esto activará el listener para limpiar _user y _userProfile
          _errorMessage = "Acceso denegado. No es administrador.";
          // _isLoadingProfile ya se puso false en _loadUserProfile (o se pondrá false por el listener de signOut)
          // No necesitamos un notifyListeners() aquí si signOut lo hace o el listener de auth lo hace.
          return false;
        }
        // Si es admin y el perfil cargó, _isLoadingProfile está en false.
        return true;
      }
      // Si signedInUserAuth es null (no debería pasar sin excepción)
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _errorMessage = null;
    // No es necesario manejar _isLoadingProfile aquí directamente;
    // el listener de _authService.user limpiará _userProfile y pondrá _isLoadingProfile a false.
    // notifyListeners(); // Opcional: notificar que el proceso de signOut ha comenzado

    try {
      await _authService.signOut();
      // El listener de _authService.user se encargará de actualizar el estado (_user, _userProfile, isLoadingProfile).
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners(); // Notificar si hay un error durante el signOut.
    }
  }

  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _userAuthSubscription.cancel(); // Muy importante cancelar la suscripción para evitar memory leaks
    super.dispose();
  }
}