import 'package:flutter/material.dart';
import '../firestore_service.dart';
import '../auth_service.dart'; // Si necesitas info del admin logueado
import '../models/product_model.dart';
import '../models/order_model.dart';

class AdminProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final AuthService _authService; // Opcional

  AdminProvider(this._firestoreService, this._authService); // Opcional authService

  // Para Catálogo
  List<ProductModel> _allProducts = [];
  bool _isLoadingProducts = false;
  String? _productsErrorMessage;

  List<ProductModel> get allProducts => _allProducts;
  bool get isLoadingProducts => _isLoadingProducts;
  String? get productsErrorMessage => _productsErrorMessage;

  Future<void> fetchAllProducts() async {
    _isLoadingProducts = true;
    notifyListeners();
    try {
      // Necesitarás un método en FirestoreService que no filtre por isAvailable, o uno específico para admin
      _firestoreService.getCollectionStream('products').listen((snapshot) { // Ejemplo genérico
        _allProducts = snapshot.docs.map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
        _isLoadingProducts = false;
        _productsErrorMessage = null;
        notifyListeners();
      });
    } catch (e) {
      _productsErrorMessage = e.toString();
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(ProductModel product) async {
    // Lógica para agregar producto
    _isLoadingProducts = true;
    notifyListeners();
    try {
      await _firestoreService.addProduct(product);
      _isLoadingProducts = false;
      notifyListeners();
      return true;
    } catch (e) {
      _productsErrorMessage = e.toString();
      _isLoadingProducts = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String productId, ProductModel product) async {
    // Lógica para actualizar producto
     _isLoadingProducts = true;
    notifyListeners();
    try {
      await _firestoreService.updateProduct(productId, product);
      _isLoadingProducts = false;
      notifyListeners();
      return true;
    } catch (e) {
      _productsErrorMessage = e.toString();
      _isLoadingProducts = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    // Lógica para eliminar producto
     _isLoadingProducts = true;
    notifyListeners();
    try {
      await _firestoreService.deleteProduct(productId);
      _isLoadingProducts = false;
      notifyListeners();
      return true;
    } catch (e) {
      _productsErrorMessage = e.toString();
      _isLoadingProducts = false;
      notifyListeners();
      return false;
    }
  }

  // Para Órdenes
  List<OrderModel> _allOrders = [];
  bool _isLoadingOrders = false;
  String? _ordersErrorMessage;
  
  List<OrderModel> get allOrders => _allOrders;
  bool get isLoadingOrders => _isLoadingOrders;
  String? get ordersErrorMessage => _ordersErrorMessage;


  Future<void> fetchAllOrders() async {
    _isLoadingOrders = true;
    notifyListeners();
    try {
      _firestoreService.getAllOrdersStream().listen((ordersData) {
        _allOrders = ordersData;
        _isLoadingOrders = false;
        _ordersErrorMessage = null;
        notifyListeners();
      });
    } catch (e) {
      _ordersErrorMessage = e.toString();
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    _isLoadingOrders = true;
    notifyListeners();
    try {
      await _firestoreService.updateOrderStatus(orderId, newStatus);
      // Podrías querer recargar solo esa orden o toda la lista
      // fetchAllOrders(); // O una actualización más optimizada
      _isLoadingOrders = false;
      notifyListeners();
      return true;
    } catch (e) {
      _ordersErrorMessage = e.toString();
      _isLoadingOrders = false;
      notifyListeners();
      return false;
    }
  }
}