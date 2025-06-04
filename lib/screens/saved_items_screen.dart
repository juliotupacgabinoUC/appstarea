import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/saved_items_provider.dart'; // Necesitarías este provider
// import '../providers/auth_provider.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final savedItemsProvider = Provider.of<SavedItemsProvider>(context);
    // final authProvider = Provider.of<AppAuthProvider>(context);

    // if (!authProvider.isAuthenticated) {
    //   return Scaffold(
    //     appBar: AppBar(title: Text('Productos Guardados')),
    //     body: Center(
    //       child: Text('Inicia sesión para ver tus productos guardados.'),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Guardados'),
      ),
      body: const Center(
        child: Text('Contenido para Productos Guardados (requiere SavedItemsProvider).'),
        // Aquí iría la lógica para mostrar los ítems guardados, similar a HomeScreen o CartScreen.
        // Ejemplo:
        // savedItemsProvider.isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : savedItemsProvider.items.isEmpty
        //         ? Center(child: Text('No tienes productos guardados.'))
        //         : ListView.builder(
        //             itemCount: savedItemsProvider.items.length,
        //             itemBuilder: (ctx, i) => ProductCard(product: savedItemsProvider.items[i]),
        //           ),
      ),
    );
  }
}