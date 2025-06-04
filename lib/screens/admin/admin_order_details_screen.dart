import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../models/cart_item_model.dart';
import '../../providers/admin_provider.dart'; // Para actualizar estado

class AdminOrderDetailsScreen extends StatefulWidget {
  final OrderModel order; // Recibe la orden completa

  const AdminOrderDetailsScreen({super.key, required this.order});

  @override
  State<AdminOrderDetailsScreen> createState() => _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  late String _currentStatus;
  final List<String> _statusOptions = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  Future<void> _updateStatus(String newStatus) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final success = await adminProvider.updateOrderStatus(widget.order.id!, newStatus);
    if (success && mounted) {
      setState(() {
        _currentStatus = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado del pedido actualizado.'), backgroundColor: Colors.green),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado: ${adminProvider.ordersErrorMessage ?? "Error desconocido"}')),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, textAlign: TextAlign.end, overflow: TextOverflow.ellipsis,)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Pedido #${widget.order.id?.substring(0,8)}...'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Información del Cliente', style: Theme.of(context).textTheme.headlineSmall),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                   _buildDetailRow('ID Cliente:', widget.order.userId),
                   // Aquí podrías cargar y mostrar más info del cliente si la tienes
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Text('Información del Pedido', style: Theme.of(context).textTheme.headlineSmall),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildDetailRow('ID Pedido:', widget.order.id ?? 'N/A'),
                    _buildDetailRow('Fecha:', '${widget.order.createdAt.toDate().day}/${widget.order.createdAt.toDate().month}/${widget.order.createdAt.toDate().year}'),
                    _buildDetailRow('Método de Pago:', widget.order.paymentMethod),
                    _buildDetailRow('Total:', '\$${widget.order.totalAmount.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Dirección de Envío', style: Theme.of(context).textTheme.titleLarge),
            Card(child: Padding(padding: const EdgeInsets.all(12.0), child: Text(widget.order.shippingAddress))),
            const SizedBox(height: 20),

            Text('Estado del Pedido', style: Theme.of(context).textTheme.titleLarge),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: _currentStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status.substring(0,1).toUpperCase() + status.substring(1)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _currentStatus) {
                  _updateStatus(newValue);
                }
              },
            ),
            const SizedBox(height: 20),

            Text('Artículos (${widget.order.items.length})', style: Theme.of(context).textTheme.titleLarge),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.order.items.length,
              itemBuilder: (ctx, index) {
                final CartItemModel item = widget.order.items[index];
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
          ],
        ),
      ),
    );
  }
}