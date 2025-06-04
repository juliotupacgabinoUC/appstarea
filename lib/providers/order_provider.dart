import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firestore_service.dart';
import '../auth_service.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final AuthService _authService; // Para obtener el userId

  List<OrderModel> _orders = [];
  OrderModel? _selectedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  OrderProvider(this._firestoreService, this._authService);

  List<OrderModel> get orders => _orders;
  OrderModel? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserOrders() async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) {
      _errorMessage = "Usuario no autenticado.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getUserOrdersStream(userId).listen((ordersData) {
        _orders = ordersData;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      });
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchOrderById(String orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedOrder = await _firestoreService.getOrderById(orderId);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> placeOrder({
    required List<CartItemModel> cartItems,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) {
      _errorMessage = "Usuario no autenticado para realizar el pedido.";
      notifyListeners();
      return false;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final newOrder = OrderModel(
        userId: userId,
        items: cartItems,
        totalAmount: totalAmount,
        status: 'pending', // Estado inicial
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        createdAt: Timestamp.now(), // O Timestamp.now() si prefieres consistencia con Firestore
      );
      await _firestoreService.placeOrder(newOrder);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      // Podrías querer limpiar el carrito aquí: Provider.of<CartProvider>(context, listen: false).clearCart();
      return true;
    } catch (e) {
      _errorMessage = "Error al realizar el pedido: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}