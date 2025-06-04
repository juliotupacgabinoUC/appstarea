import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart'; // Necesitarás un modelo para los ítems del carrito/orden

class OrderModel {
  final String? id;
  final String userId;
  final List<CartItemModel> items; // Lista de productos en la orden
  final double totalAmount;
  final String status; // Ej: 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
  final String shippingAddress; // Podría ser un objeto más complejo AddressModel
  final String paymentMethod; // Ej: 'tarjeta_credito', 'paypal'
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String documentId) {
    return OrderModel(
      id: documentId,
      userId: data['userId'] as String,
      items: (data['items'] as List<dynamic>)
          .map((itemData) => CartItemModel.fromMap(itemData as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: data['status'] as String,
      shippingAddress: data['shippingAddress'] as String,
      paymentMethod: data['paymentMethod'] as String,
      createdAt: data['createdAt'] as Timestamp,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }
}

// Crea lib/models/cart_item_model.dart (ejemplo simple)
// class CartItemModel {
//   final String productId;
//   final String productName;
//   final int quantity;
//   final double price;
//   final String imageUrl;

//   CartItemModel({
//     required this.productId,
//     required this.productName,
//     required this.quantity,
//     required this.price,
//     required this.imageUrl,
//   });

//   factory CartItemModel.fromMap(Map<String, dynamic> map) {
//     return CartItemModel(
//       productId: map['productId'] as String,
//       productName: map['productName'] as String,
//       quantity: map['quantity'] as int,
//       price: (map['price'] as num).toDouble(),
//       imageUrl: map['imageUrl'] as String? ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'productId': productId,
//       'productName': productName,
//       'quantity': quantity,
//       'price': price,
//       'imageUrl': imageUrl,
//     };
//   }
// }