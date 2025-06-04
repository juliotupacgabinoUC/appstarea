import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// Importa las otras pantallas de admin para la navegación
// import 'admin_catalog_screen.dart';
// import 'admin_order_list_screen.dart';
// import 'admin_account_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Widget _buildDashboardItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2, // Dos columnas
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: <Widget>[
          _buildDashboardItem(
            context: context,
            icon: Icons.storefront_outlined,
            title: 'Gestionar Catálogo',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCatalogScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Catálogo Admin pendiente.')),
              );
            },
          ),
          _buildDashboardItem(
            context: context,
            icon: Icons.receipt_long_outlined,
            title: 'Ver Pedidos',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminOrderListScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Lista de Pedidos Admin pendiente.')),
              );
            },
          ),
           _buildDashboardItem(
            context: context,
            icon: Icons.bar_chart_outlined, // Opcional
            title: 'Estadísticas', // Opcional
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad de Estadísticas pendiente.')),
              );
            },
          ),
          _buildDashboardItem(
            context: context,
            icon: Icons.settings_outlined,
            title: 'Configuración', // Opcional
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidad de Configuración pendiente.')),
              );
            },
          ),
          _buildDashboardItem(
            context: context,
            icon: Icons.account_circle_outlined,
            title: 'Mi Cuenta Admin',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAccountScreen()));
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Cuenta Admin pendiente.')),
              );
            },
          ),
        ],
      ),
    );
  }
}