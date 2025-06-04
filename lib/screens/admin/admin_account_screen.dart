import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Para info del admin

class AdminAccountScreen extends StatelessWidget {
  const AdminAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final adminProfile = authProvider.userProfile; // Asume que el perfil de admin está cargado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta de Administrador'),
      ),
      body: adminProfile == null
          ? const Center(child: Text('No se pudo cargar el perfil del administrador.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: adminProfile.photoURL != null && adminProfile.photoURL!.isNotEmpty
                            ? NetworkImage(adminProfile.photoURL!)
                            : null,
                        child: adminProfile.photoURL == null || adminProfile.photoURL!.isEmpty
                            ? const Icon(Icons.admin_panel_settings, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: const Text('Nombre Admin'),
                        subtitle: Text(adminProfile.displayName ?? 'Admin'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email Admin'),
                        subtitle: Text(adminProfile.email ?? 'No disponible'),
                      ),
                    ),
                    // Aquí podrías agregar opciones para cambiar contraseña de admin (si Firebase lo permite fácilmente)
                    // o editar otros detalles específicos del perfil de admin.
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para editar perfil de admin (podría ser una nueva pantalla)
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Editar Perfil Admin pendiente.')),
                        );
                      },
                      child: const Text('Editar Perfil Admin'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}