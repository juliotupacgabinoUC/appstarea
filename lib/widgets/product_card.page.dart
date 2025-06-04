import 'package:flutter/material.dart';
import '../models/product_model.dart'; // Asegúrate que la ruta al modelo sea correcta
import '../screens/product_details_screen.dart'; // Para navegar a detalles
import 'package:provider/provider.dart'; // Para el carrito
import '../providers/cart_provider.dart'; // Asegúrate que la ruta al provider sea correcta


class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false); // Para acciones

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias, // Para que el InkWell respete los bordes redondeados
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados para la tarjeta
      ),
      child: InkWell(
        onTap: () {
          // Asegúrate que la navegación a ProductDetailsScreen esté bien configurada
          // y que ProductDetailsScreen acepte productId.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(productId: product.id!),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3, // Más espacio para la imagen
              child: Hero(
                tag: product.id!, // Misma tag que en ProductDetailsScreen para la animación
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover, // Cubrir el espacio disponible
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40)),
                        ),
                      )
                    : Container( // Placeholder si no hay imagen
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40)),
                      ),
              ),
            ),
            Expanded(
              flex: 2, // Espacio para texto y botón
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye el espacio
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center, // Alinear verticalmente
                      children: [
                        Text(
                          // Asegúrate que el precio se formatea correctamente
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 15, // Tamaño de fuente consistente
                          ),
                        ),
                        if (product.isAvailable && product.stock > 0)
                          Tooltip(
                            message: 'Agregar al carrito',
                            child: SizedBox( // Controlar tamaño del área de toque del botón
                              height: 36,
                              width: 36,
                              child: IconButton(
                                icon: Icon(Icons.add_shopping_cart_outlined, color: Theme.of(context).colorScheme.secondary, size: 20),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                   cartProvider.addItem(product);
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} agregado al carrito.'),
                                      duration: const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      action: SnackBarAction(
                                        label: 'VER',
                                        textColor: Colors.yellowAccent,
                                        onPressed: (){
                                          // Ajusta la ruta del carrito si es necesario y si usas rutas nombradas
                                          Navigator.pushNamed(context, '/cart');
                                          
                                          // O: Navigator.pushNamed(context, '/cart'); Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                                        }
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else
                           Padding(
                             padding: const EdgeInsets.only(top: 4.0), // Pequeño ajuste para alinear si es necesario
                             child: Text(
                               product.stock <= 0 ? 'Agotado' : 'No disp.', // Más corto
                               style: TextStyle(color: Colors.red.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                             ),
                           ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}