// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Configuración de Firebase y Rutas
import 'firebase_options.dart'; // Auto-generado por FlutterFire
import 'routes.dart';         // Tu archivo de definición de rutas (AppRoutes)

// Servicios
import 'auth_service.dart';
import 'firestore_service.dart';

// Modelos
import 'models/user_model.dart'; // Necesario para AuthWrapper y AppAuthProvider

// Providers
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/admin_provider.dart';

// Pantallas que AuthWrapper podría necesitar instanciar directamente
// (otras pantallas se cargan a través de AppRoutes.generateRoute)
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
// LoginScreen es invocado por WelcomeScreen a través de rutas nombradas,
// por lo que no es estrictamente necesario importarlo aquí si no se usa directamente en main.dart.
// import 'screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancias de los servicios
    // En apps más grandes, podrías usar un localizador de servicios como get_it.
    final authService = AuthService();
    final firestoreService = FirestoreService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => ProductProvider(firestoreService)),
        ChangeNotifierProvider(create: (_) => CartProvider(firestoreService)),
        ChangeNotifierProvider(create: (_) => OrderProvider(firestoreService, authService)),
        ChangeNotifierProvider(create: (_) => AdminProvider(firestoreService, authService)),
        // Agrega otros providers globales aquí si los necesitas
      ],
      child: MaterialApp(
        title: 'Tienda de Figuras 3D',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Considera definir un ColorScheme más completo aquí:
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          // useMaterial3: true, // Para optar por Material 3
          // Aquí puedes definir más aspectos de tu tema:
          // textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme), // Ejemplo con Google Fonts
          // elevatedButtonTheme: ElevatedButtonThemeData(...)
        ),
        debugShowCheckedModeBanner: false,
        // Usar rutas nombradas definidas en routes.dart
        initialRoute: AppRoutes.authWrapper, // AuthWrapper decide la primera pantalla real
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

// AuthWrapper decide qué pantalla mostrar basada en el estado de autenticación y el perfil.
// Esta clase NO debe estar en routes.dart si routes.dart la importa, para evitar dependencias circulares.
// Es correcto que esté aquí en main.dart o en su propio archivo (ej. lib/widgets/auth_wrapper.dart)
// y luego se importe en routes.dart.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // static const routeName = AppRoutes.authWrapper; // Definido en AppRoutes

  @override
  Widget build(BuildContext context) {
    // Obtener el AppAuthProvider una sola vez si es posible, o usar Consumer donde se necesite reactividad.
    // Aquí, el StreamBuilder reacciona al stream, y el Consumer al perfil.
    final authProviderForStream = Provider.of<AppAuthProvider>(context, listen: false);

    return StreamBuilder<UserModel?>(
      stream: authProviderForStream.userAuthStream, // Stream del usuario básico de Firebase Auth
      builder: (context, authSnapshot) {
        // Estado 1: Esperando la respuesta inicial de Firebase Auth
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // Muestra pantalla de carga
        }

        // Estado 2: Error al obtener el usuario de Firebase Auth
        if (authSnapshot.hasError) {
          // Podrías mostrar un mensaje de error más específico o un botón para reintentar
          return const Scaffold(
            body: Center(
              child: Text("Error de conexión con el servicio de autenticación."),
            ),
          );
        }

        // Estado 3: No hay usuario de Firebase Auth (usuario no autenticado)
        if (authSnapshot.data == null) {
          return const WelcomeScreen(); // Dirigir a la pantalla de bienvenida para elegir login
        }

        // Estado 4: Hay un usuario de Firebase Auth. Ahora necesitamos el perfil de Firestore para el rol.
        // Usamos un Consumer para reaccionar a los cambios en isLoadingProfile y userProfile.
        return Consumer<AppAuthProvider>(
          builder: (context, consumedAuthProvider, _) {
            // Estado 4a: El perfil de Firestore (con el rol) se está cargando
            if (consumedAuthProvider.isLoadingProfile) {
              return const SplashScreen(); // Muestra pantalla de carga
            }

            // Estado 4b: Hubo un usuario de Auth, pero el perfil de Firestore es null y no está cargando
            // Esto podría significar que el perfil no se pudo cargar o no existe (ej. error en signUp).
            if (consumedAuthProvider.userProfile == null) {
              print("AuthWrapper: Usuario de Auth existe (${authSnapshot.data!.uid}), pero userProfile de Firestore es null (y no está cargando).");
              // Es una situación anómala. Podrías:
              // 1. Intentar recargar el perfil.
              // 2. Desloguear al usuario y enviarlo a WelcomeScreen.
              // 3. Mostrar una pantalla de error específica.
              // Por ahora, lo enviamos a WelcomeScreen.
              // Considera añadir un signOut aquí si es un estado inválido persistente.
              // Future.microtask(() => consumedAuthProvider.signOut()); // Opción drástica
              return const WelcomeScreen(); // O una pantalla de "Error al cargar perfil"
            }

            // Estado 4c: Tenemos el perfil de Firestore y podemos verificar el rol.
            if (consumedAuthProvider.isAdmin) {
              return const AdminDashboardScreen(); // Dirigir al panel de administrador
            } else {
              return const HomeScreen(); // Dirigir a la pantalla principal de cliente
            }
          },
        );
      },
    );
  }
}