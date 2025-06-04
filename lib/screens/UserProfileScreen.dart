import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/account_page.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> initialUserData;

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.initialUserData,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userData = widget.initialUserData;
  }

  Future<void> _fetchLatestUserData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.userId)
          .get();
      if (mounted && userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AccountPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad de editar perfil no implementada aún.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _userData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_userData == null) {
         return Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil')),
        body: const Center(child: Text('No se pudieron cargar los datos del usuario.')),
      );
    }

    String nombre = _userData!['nombre'] ?? 'N/A';
    String email = _userData!['email'] ?? 'N/A';
    Timestamp? fechaCreacionTimestamp = _userData!['fechaCreacion'];
    String fechaCreacionStr = 'N/A';
    if (fechaCreacionTimestamp != null) {
      DateTime fechaCreacion = fechaCreacionTimestamp.toDate();
      fechaCreacionStr = '${fechaCreacion.day.toString().padLeft(2, '0')}/${fechaCreacion.month.toString().padLeft(2, '0')}/${fechaCreacion.year}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 40, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      nombre,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Miembro desde: $fechaCreacionStr',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Editar Datos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )
              ),
              onPressed: _navigateToEditProfile,
            ),
            const SizedBox(height: 12),
             OutlinedButton.icon(
              icon: const Icon(Icons.exit_to_app, color: Colors.red), // Cambiado para mayor claridad
              label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )
              ),
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}