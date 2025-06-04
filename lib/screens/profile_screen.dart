// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
// import 'edit_profile_screen.dart'; // Necesitarías esta pantalla si la implementas
// import 'purchase_history_screen.dart'; // Para ver historial (o usa rutas nombradas)
import '../routes.dart'; // Si usas rutas nombradas para la navegación

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final userProfile = authProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar Perfil',
            onPressed: () {
              // Navegar a una pantalla para editar perfil
              // if (userProfile != null) {
              //   Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(user: userProfile)));
              // } else {
              //    SnackbarHelper.showErrorSnackbar(context, "Perfil no disponible para editar.");
              // }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Editar Perfil pendiente.')),
              );
            },
          ),
        ],
      ),
      // 👇 CORRECCIÓN AQUÍ y ABAJO 👇
      body: authProvider.isLoadingProfile && userProfile == null // Muestra carga si el perfil está cargando Y aún no hay datos
          ? const Center(child: CircularProgressIndicator())
          : userProfile == null && !authProvider.isLoadingProfile // Muestra error si NO está cargando Y no hay perfil
              ? const Center(child: Text('No se pudo cargar el perfil. Intenta de nuevo.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: userProfile?.photoURL != null && userProfile!.photoURL!.isNotEmpty
                              ? NetworkImage(userProfile.photoURL!)
                              : null,
                          child: userProfile?.photoURL == null || userProfile!.photoURL!.isEmpty
                              ? Icon(Icons.person_outline, size: 50, color: Colors.grey.shade700)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: const Icon(Icons.person_pin_outlined),
                          title: const Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(userProfile?.displayName ?? 'No disponible'),
                        ),
                      ),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(userProfile?.email ?? 'No disponible'),
                        ),
                      ),
                      // Agrega más campos del perfil aquí si los tienes
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.history_edu_outlined),
                        title: const Text('Historial de Compras'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                           // Navigator.pushNamed(context, AppRoutes.purchaseHistory);
                           ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Navegación a Historial pendiente.')),
                           );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite_outline),
                        title: const Text('Productos Guardados'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigator.pushNamed(context, AppRoutes.savedItems);
                           ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Navegación a Guardados pendiente.')),
                           );
                        },
                      ),
                      // Solo mostrar Panel de Administrador si el usuario es admin
                      if (authProvider.isAdmin) ...[
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings_outlined),
                          title: const Text('Panel de Administrador'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                             Navigator.pushNamed(context, AppRoutes.adminDashboard);
                          },
                        ),
                        const Divider(),
                      ],
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout_outlined),
                          label: const Text('Cerrar Sesión'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          ),
                          onPressed: () async {
                            final navigator = Navigator.of(context); // Guardar Navigator antes del await
                            await authProvider.signOut();
                            // AuthWrapper debería manejar la redirección a la pantalla de login/welcome
                            // Si necesitas asegurar que esta pantalla se quite del stack:
                            if (mounted) { // 'mounted' está disponible porque ahora es StatefulWidget
                               navigator.pushNamedAndRemoveUntil(AppRoutes.authWrapper, (route) => false);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}