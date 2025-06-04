import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .fetchOrderById(widget.orderId);
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final OrderModel? order = orderProvider.selectedOrder;

    return Scaffold(
      appBar: AppBar(
        title: Text(order != null ? 'Detalle Pedido #${order.id?.substring(0,8)}...' : 'Detalle del Pedido'),
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.errorMessage != null
              ? Center(child: Text('Error: ${orderProvider.errorMessage}'))
              : order == null
                  ? const Center(child: Text('Pedido no encontrado.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Información del Pedido', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 10),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  _buildDetailRow('ID Pedido:', order.id ?? 'N/A'),
                                  _buildDetailRow('Fecha:', '${order.createdAt.toDate().day}/${order.createdAt.toDate().month}/${order.createdAt.toDate().year}'),
                                  _buildDetailRow('Estado:', order.status),
                                  _buildDetailRow('Método de Pago:', order.paymentMethod),
                                  _buildDetailRow('Total:', '\$${order.totalAmount.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Dirección de Envío', style: Theme.of(context).textTheme.titleLarge),
                          Card(
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(order.shippingAddress)
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Artículos (${order.items.length})', style: Theme.of(context).textTheme.titleLarge),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.items.length,
                            itemBuilder: (ctx, index) {
                              final CartItemModel item = order.items[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image_not_supported)),
                                  title: Text(item.productName),
                                  subtitle: Text('Cantidad: ${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                                  trailing: Text('\$${(item.quantity * item.price).toStringAsFixed(2)}'),
                                ),
                              );
                            },
                          ),
                           const SizedBox(height: 20),
                          // Puedes agregar opciones como "Rastrear pedido", "Contactar Soporte", etc.
                        ],
                      ),
                    ),
    );
  }
}