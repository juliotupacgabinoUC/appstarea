import 'package:flutter/material.dart';
import '../models/cart_item_model.dart'; // Necesitas este modelo
import '../models/product_model.dart';
import '../firestore_service.dart'; // Para persistir carrito si es necesario

class CartProvider extends ChangeNotifier {
  final FirestoreService _firestoreService; // Opcional, si el carrito se guarda en Firestore
  Map<String, CartItemModel> _items = {};

  CartProvider(this._firestoreService); // Opcional

  Map<String, CartItemModel> get items => {..._items};
  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(ProductModel product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id!,
        (existingCartItem) => CartItemModel(
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          quantity: existingCartItem.quantity + quantity,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id!,
        () => CartItemModel(
          productId: product.id!,
          productName: product.name,
          quantity: quantity,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
    }
    notifyListeners();
    // Opcional: _saveCartToFirestore();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    // Opcional: _saveCartToFirestore();
  }

  void removeSingleItem(String productId) { // Reduce la cantidad o elimina si es 1
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItemModel(
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    // Opcional: _saveCartToFirestore();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
    // Opcional: _deleteCartFromFirestore();
  }

  // Opcional: Métodos para cargar/guardar carrito en Firestore si quieres que persista entre sesiones/dispositivos
  // Future<void> _loadCartFromFirestore(String userId) async { ... }
  // Future<void> _saveCartToFirestore(String userId) async { ... }
}