import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/order_model.dart';
// import 'admin_order_details_screen.dart';

class AdminOrderListScreen extends StatefulWidget {
  const AdminOrderListScreen({super.key});

  @override
  State<AdminOrderListScreen> createState() => _AdminOrderListScreenState();
}

class _AdminOrderListScreenState extends State<AdminOrderListScreen> {
  String _selectedStatusFilter = 'Todos'; // Filtro inicial
  final List<String> _statusOptions = ['Todos', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    List<OrderModel> filteredOrders = adminProvider.allOrders;
    if (_selectedStatusFilter != 'Todos') {
      filteredOrders = adminProvider.allOrders.where((order) => order.status == _selectedStatusFilter).toList();
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pedidos'),
      ),
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filtrar por Estado',
                border: OutlineInputBorder(),
              ),
              value: _selectedStatusFilter,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status.substring(0,1).toUpperCase() + status.substring(1)), // Capitalizar
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatusFilter = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: adminProvider.isLoadingOrders
                ? const Center(child: CircularProgressIndicator())
                : adminProvider.ordersErrorMessage != null
                    ? Center(child: Text('Error: ${adminProvider.ordersErrorMessage}'))
                    : filteredOrders.isEmpty
                        ? Center(child: Text(_selectedStatusFilter == 'Todos' ? 'No hay pedidos.' : 'No hay pedidos con estado "$_selectedStatusFilter".'))
                        : ListView.builder(
                            itemCount: filteredOrders.length,
                            itemBuilder: (ctx, i) {
                              final OrderModel order = filteredOrders[i];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: ListTile(
                                  title: Text('Pedido ID: ${order.id?.substring(0,8) ?? "N/A"}...'),
                                  subtitle: Text('Cliente ID: ${order.userId.substring(0,8)}... - Estado: ${order.status}'),
                                  trailing: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (_) => AdminOrderDetailsScreen(order: order)));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Navegación a Detalles de Orden Admin (${order.id}) pendiente.')),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}