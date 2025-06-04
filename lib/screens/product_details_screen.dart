import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart'; // Para agregar al carrito
import '../models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false); // No necesita escuchar cambios aquí

    final ProductModel? product = productProvider.selectedProduct;

    return Scaffold(
      appBar: AppBar(
        title: Text(product?.name ?? 'Detalle del Producto'),
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
              ? Center(child: Text('Error: ${productProvider.errorMessage}'))
              : product == null
                  ? const Center(child: Text('Producto no encontrado.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.imageUrl.isNotEmpty)
                            Center(
                              child: Hero( // Animación de imagen
                                tag: product.id!,
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  height: 300,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text('Categoría: ${product.categoryName}'),
                          if (product.stock > 0) Text('Stock: ${product.stock} disponibles'),
                          const SizedBox(height: 16),
                          Text('Descripción:', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 24),
                          if (product.isAvailable && product.stock > 0)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Agregar al Carrito'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                cartProvider.addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} agregado al carrito.'),
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(label: "VER", onPressed: (){
                                      Navigator.pushNamed(context, '/cart'); // Asumiendo ruta del carrito
                                    }),
                                  ),
                                );
                              },
                            )
                          else
                            Text(
                              product.stock <= 0 ? 'Agotado' : 'No disponible',
                              style: TextStyle(fontSize: 18, color: Colors.red[700], fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            // Botón de Guardar/Favoritos
                            OutlinedButton.icon(
                                icon: const Icon(Icons.favorite_border), // Cambiar a Icons.favorite si ya está guardado
                                label: const Text('Guardar en Favoritos'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: (){
                                    // Lógica para guardar en favoritos
                                    // Necesitaría un SavedItemsProvider y autenticación
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Funcionalidad "Guardar" pendiente')),
                                    );
                                },
                            )
                        ],
                      ),
                    ),
    );
  }
}