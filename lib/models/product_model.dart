import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id; // Opcional si Firestore genera el ID
  final String name;
  final String description;
  final double price;
  final String imageUrl; // URL de la imagen (quizás de Firebase Storage)
  final String categoryId; // ID de la categoría a la que pertenece
  final String categoryName; // Nombre de la categoría (para mostrar fácilmente)
  final int stock;
  final bool isAvailable;
  final bool isFeatured;
  final Timestamp? createdAt;
  // Agrega más campos como dimensiones, material, etc.

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    this.stock = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] as String,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
      categoryId: data['categoryId'] as String,
      categoryName: data['categoryName'] as String? ?? 'Sin Categoría',
      stock: data['stock'] as int? ?? 0,
      isAvailable: data['isAvailable'] as bool? ?? true,
      isFeatured: data['isFeatured'] as bool? ?? false,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'stock': stock,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(), // Guarda la hora del servidor al crear
    };
  }

   ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    int? stock,
    bool? isAvailable,
    bool? isFeatured,
    Timestamp? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}