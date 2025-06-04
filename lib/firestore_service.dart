import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product_model.dart';
import 'models/user_model.dart';
import 'models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Métodos genéricos (ejemplos) ---
  Future<DocumentSnapshot> getDocument(String collectionPath, String documentId) {
    return _db.collection(collectionPath).doc(documentId).get();
  }

  Stream<QuerySnapshot> getCollectionStream(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }

  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) {
    return _db.collection(collectionPath).add(data);
  }
   Future<void> setDocument(String collectionPath, String documentId, Map<String, dynamic> data) {
    return _db.collection(collectionPath).doc(documentId).set(data);
  }

  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data) {
    return _db.collection(collectionPath).doc(documentId).update(data);
  }

  Future<void> deleteDocument(String collectionPath, String documentId) {
    return _db.collection(collectionPath).doc(documentId).delete();
  }

  // --- Métodos específicos para Usuarios ---
  Future<void> setUserProfile(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, uid); // Asumiendo fromMap en UserModel
    }
    return null;
  }

  // Ejemplo de verificación de rol admin
  Future<bool> isAdminUser(String uid) async {
    final userProfile = await getUserProfile(uid);
    return userProfile?.isAdmin ?? false; // Asumiendo campo isAdmin en UserModel
  }


  // --- Métodos específicos para Productos ---
  Stream<List<ProductModel>> getProductsStream() {
    return _db.collection('products').where('isAvailable', isEqualTo: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
  
  Stream<List<ProductModel>> getProductsByCategoryStream(String categoryId) {
    return _db.collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('isAvailable', isEqualTo: true)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _db.collection('products').doc(productId).get();
     if (doc.exists) {
      return ProductModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> addProduct(ProductModel product) {
    return _db.collection('products').add(product.toMap()); // Asumiendo toMap en ProductModel
  }

  Future<void> updateProduct(String productId, ProductModel product) {
    return _db.collection('products').doc(productId).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  // --- Métodos específicos para Órdenes ---
  Future<void> placeOrder(OrderModel order) {
    return _db.collection('orders').add(order.toMap()); // Asumiendo toMap en OrderModel
  }

  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _db.collection('orders').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Stream<List<OrderModel>> getAllOrdersStream() { // Para Admin
    return _db.collection('orders').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
   Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _db.collection('orders').doc(orderId).get();
     if (doc.exists) {
      return OrderModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updateOrderStatus(String orderId, String status) {
    return _db.collection('orders').doc(orderId).update({'status': status, 'updatedAt': Timestamp.now()});
  }

  // --- Métodos para Categorías (ejemplo) ---
  Stream<List<Map<String, dynamic>>> getCategoriesStream() { // O un CategoryModel
    return _db.collection('categories').orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }
}