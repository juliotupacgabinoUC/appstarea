import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';
// import 'checkout_screen.dart'; // Para ir al checkout

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // static const routeName = AppRoutes.cart;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cart.items.isEmpty
                ? const Center(
                    child: Text('Tu carrito está vacío.', style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItemEntry = cart.items.entries.toList()[i];
                      final CartItemModel cartItem = cartItemEntry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(cartItem.imageUrl),
                              onBackgroundImageError: (_, __) {}, // Manejo de error de imagen
                              child: cartItem.imageUrl.isEmpty ? const Icon(Icons.image) : null,
                            ),
                            title: Text(cartItem.productName),
                            subtitle: Text('Total: \$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
                            trailing: SizedBox(
                              width: 120, // Ajusta el ancho según sea necesario
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      cart.removeSingleItem(cartItem.productId);
                                    },
                                  ),
                                  Text('${cartItem.quantity}x'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      // Para agregar, necesitas el ProductModel.
                                      // Aquí deberías tener una forma de obtener el ProductModel correspondiente
                                      // o modificar addItem para que acepte solo productId si el producto ya está en el carrito.
                                      // Por simplicidad, asumiremos que tienes el producto o lo buscas.
                                      // Esta parte requiere una lógica más robusta para recrear ProductModel o
                                      // tener una lista de productos disponibles.
                                      // Ejemplo conceptual (NO FUNCIONAL SIN PRODUCT MODEL):
                                      // final productProvider = Provider.of<ProductProvider>(context, listen: false);
                                      // final product = productProvider.findById(cartItem.productId);
                                      // if (product != null) cart.addItem(product);
                                       ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Incrementar cantidad pendiente de lógica producto.')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () { // O un botón de eliminar explícito
                              cart.removeItem(cartItem.productId);
                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${cartItem.productName} eliminado del carrito.')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (cart.items.isNotEmpty)
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: (cart.totalAmount <= 0) // Deshabilitar si el total es 0 o negativo
                          ? null
                          : () {
                              // Navegar a CheckoutScreen
                              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Navegación a Checkout pendiente.')),
                              );
                            },
                      child: Text('PROCEDER AL PAGO', style: TextStyle(color: Theme.of(context).primaryColor)),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}