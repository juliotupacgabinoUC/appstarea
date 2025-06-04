import 'package:flutter/material.dart';
import '../firestore_service.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  List<ProductModel> _products = [];
  List<ProductModel> _categoryProducts = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  ProductProvider(this._firestoreService);

  List<ProductModel> get products => _products;
  List<ProductModel> get categoryProducts => _categoryProducts;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getProductsStream().listen((productsData) {
        _products = productsData;
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

  Future<void> fetchProductsByCategory(String categoryId) async {
    // Similar a fetchProducts pero con getProductsByCategoryStream
    _isLoading = true;
    notifyListeners();
    try {
      _firestoreService.getProductsByCategoryStream(categoryId).listen((productsData) {
        _categoryProducts = productsData;
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

  Future<void> fetchProductById(String productId) async {
     _isLoading = true;
    notifyListeners();
    try {
      _selectedProduct = await _firestoreService.getProductById(productId);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Métodos para admin (addProduct, updateProduct, deleteProduct) irían en AdminProvider
  // o aquí si este provider es usado por ambos, con verificaciones de rol.
}