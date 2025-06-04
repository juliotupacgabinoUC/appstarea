

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isAdmin; // Para diferenciar roles
  // Agrega más campos según necesites (dirección, teléfono, etc.)

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.isAdmin = false,
  });

  // Constructor para crear UserModel desde un DocumentSnapshot de Firestore
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoURL: data['photoURL'] as String?,
      isAdmin: data['isAdmin'] as bool? ?? false,
      // Mapea otros campos
    );
  }

  // Método para convertir UserModel a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isAdmin': isAdmin,
      // Mapea otros campos
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}