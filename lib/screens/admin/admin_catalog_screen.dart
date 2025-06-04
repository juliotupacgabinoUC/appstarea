import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/product_model.dart';
// import 'admin_add_edit_product_screen.dart';

class AdminCatalogScreen extends StatefulWidget {
  const AdminCatalogScreen({super.key});

  @override
  State<AdminCatalogScreen> createState() => _AdminCatalogScreenState();
}

class _AdminCatalogScreenState extends State<AdminCatalogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAllProducts();
    });
  }

  void _deleteProduct(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: const Text('¿Estás seguro de que quieres eliminar este producto? Esta acción no se puede deshacer.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await Provider.of<AdminProvider>(context, listen: false).deleteProduct(productId);
               if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(success ? 'Producto eliminado.' : 'Error al eliminar producto.')),
                  );
               }
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Catálogo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Agregar Producto',
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAddEditProductScreen())); // Sin producto (modo agregar)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Agregar Producto pendiente.')),
              );
            },
          ),
        ],
      ),
      body: adminProvider.isLoadingProducts
          ? const Center(child: CircularProgressIndicator())
          : adminProvider.productsErrorMessage != null
              ? Center(child: Text('Error: ${adminProvider.productsErrorMessage}'))
              : adminProvider.allProducts.isEmpty
                  ? const Center(child: Text('No hay productos en el catálogo.'))
                  : ListView.builder(
                      itemCount: adminProvider.allProducts.length,
                      itemBuilder: (ctx, i) {
                        final ProductModel product = adminProvider.allProducts[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: product.imageUrl.isNotEmpty
                                ? Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                                : const Icon(Icons.image_not_supported, size: 50),
                            title: Text(product.name),
                            subtitle: Text('Precio: \$${product.price.toStringAsFixed(2)} - Stock: ${product.stock}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAddEditProductScreen(product: product))); // Con producto (modo editar)
                                     ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Navegación a Editar Producto (${product.name}) pendiente.')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _deleteProduct(context, product.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}