import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Para obtener los ítems y total

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Resumen del Pedido', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            // Lista de ítems (simplificada)
            if (cart.items.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.items.length > 3 ? 3 : cart.items.length, // Mostrar máx 3 items
                itemBuilder: (ctx, i) {
                  final item = cart.items.values.toList()[i];
                  return ListTile(
                    dense: true,
                    title: Text('${item.productName} (x${item.quantity})'),
                    trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            if (cart.items.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 16.0),
                child: Text('...y ${cart.items.length - 3} más artículos.'),
              ),
            const SizedBox(height: 8),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                  Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            // Aquí podrías agregar costos de envío, impuestos, etc.
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 4.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('Envío:', style: TextStyle(fontSize: 16)),
            //       Text('\$5.00', style: TextStyle(fontSize: 16)), // Ejemplo
            //     ],
            //   ),
            // ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    // '\$${(cart.totalAmount + 5.00).toStringAsFixed(2)}', // Ejemplo con envío
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}