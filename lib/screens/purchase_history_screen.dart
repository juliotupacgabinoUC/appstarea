import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart'; // Para asegurar que el usuario esté logueado
import '../models/order_model.dart';
// import 'order_details_screen.dart'; // Para ver detalles de una orden

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar historial de órdenes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<OrderProvider>(context, listen: false).fetchUserOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AppAuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historial de Compras')),
        body: const Center(
          child: Text('Inicia sesión para ver tu historial.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras'),
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.errorMessage != null
              ? Center(child: Text('Error: ${orderProvider.errorMessage}'))
              : orderProvider.orders.isEmpty
                  ? const Center(child: Text('Aún no has realizado ninguna compra.'))
                  : ListView.builder(
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (ctx, i) {
                        final OrderModel order = orderProvider.orders[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Text('Pedido ID: ${order.id?.substring(0, 8) ?? "N/A"}...'), // Acortar ID
                            subtitle: Text('Fecha: ${order.createdAt.toDate().day}/${order.createdAt.toDate().month}/${order.createdAt.toDate().year} - Estado: ${order.status}'),
                            trailing: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
                            onTap: () {
                              // Navegar a OrderDetailsScreen para esta orden específica
                              // Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: order.id!)));
                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Navegación a Detalles de Orden (${order.id}) pendiente.')),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}