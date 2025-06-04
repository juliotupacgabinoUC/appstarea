// lib/routes.dart
import 'package:flutter/material.dart';

// --- Importaciones Principales ---
// Asumiendo que AuthWrapper está en main.dart. Si lo moviste, ajusta la ruta.
import 'main.dart'; // Para AuthWrapper
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/purchase_history_screen.dart';
import 'screens/saved_items_screen.dart';
import 'screens/category_list_screen.dart'; // Si la tienes
import 'screens/product_list_by_category_screen.dart'; // Si la tienes
import 'screens/search_results_screen.dart'; // Si la tienes


// --- Importaciones de Pantallas de Administrador ---
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_catalog_screen.dart';
import 'screens/admin/admin_add_edit_product_screen.dart';
import 'screens/admin/admin_order_list_screen.dart';
import 'screens/admin/admin_order_details_screen.dart';
import 'screens/admin/admin_account_screen.dart';

// --- Importaciones de Modelos (si se pasan como argumentos) ---
import 'models/product_model.dart'; // Para AdminAddEditProductScreen y ProductDetailsScreen (si pasas el modelo en lugar de ID)
import 'models/order_model.dart';   // Para AdminOrderDetailsScreen

class AppRoutes {
  // --- Rutas Principales ---
  static const String authWrapper = '/'; // AuthWrapper será nuestra ruta raíz
  static const String splash = '/splash'; // Puede usarse si se navega explícitamente
  static const String welcome = '/welcome';

  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String productDetails = '/product-details'; // Necesitará un ID
  static const String orderDetails = '/order-details'; // Necesitará un ID
  static const String purchaseHistory = '/purchase-history';
  static const String savedItems = '/saved-items';
  static const String categoryList = '/categories';
  static const String productListByCategory = '/products-by-category';
  static const String searchResults = '/search-results';


  // --- Rutas de Administrador ---
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminCatalog = '/admin/catalog';
  static const String adminAddEditProduct = '/admin/product-form';
  static const String adminOrderList = '/admin/orders';
  static const String adminOrderDetails = '/admin/order-details';
  static const String adminAccount = '/admin/account';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Puedes imprimir settings.name para depurar qué ruta se está solicitando
    // print('Navegando a: ${settings.name} con argumentos: ${settings.arguments}');

    switch (settings.name) {
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper()); // AuthWrapper está en main.dart
      case splash: // No es la inicial, pero podría llamarse
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      
      case productDetails:
        final String? productId = settings.arguments as String?;
        if (productId != null) {
          return MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: productId));
        }
        return _errorRoute("ID de producto no proporcionado para $productDetails");
      
      case orderDetails:
        final String? orderId = settings.arguments as String?;
        if (orderId != null) {
          return MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: orderId));
        }
        return _errorRoute("ID de orden no proporcionado para $orderDetails");

      case purchaseHistory:
        return MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen());
      case savedItems:
        return MaterialPageRoute(builder: (_) => const SavedItemsScreen());
      case categoryList:
        return MaterialPageRoute(builder: (_) => const CategoryListScreen());
      case productListByCategory:
        // Asumiendo que pasas un mapa o un objeto CategoryModel como argumento
        final Map<String, String>? args = settings.arguments as Map<String, String>?;
        if (args != null && args['id'] != null && args['name'] != null) {
           return MaterialPageRoute(builder: (_) => ProductListByCategoryScreen(categoryId: args['id']!, categoryName: args['name']!));
        }
        return _errorRoute("Argumentos de categoría no proporcionados para $productListByCategory");
      case searchResults:
         final String? query = settings.arguments as String?;
         return MaterialPageRoute(builder: (_) => SearchResultsScreen(searchQuery: query ?? ""));


      // --- Rutas de Administrador ---
      case adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case adminCatalog:
        return MaterialPageRoute(builder: (_) => const AdminCatalogScreen());
      case adminAddEditProduct:
        final ProductModel? product = settings.arguments as ProductModel?; // Puede ser null para agregar
        return MaterialPageRoute(builder: (_) => AdminAddEditProductScreen(product: product));
      case adminOrderList:
        return MaterialPageRoute(builder: (_) => const AdminOrderListScreen());
      case adminOrderDetails:
        final OrderModel? order = settings.arguments as OrderModel?;
         if (order != null) {
          return MaterialPageRoute(builder: (_) => AdminOrderDetailsScreen(order: order));
        }
        return _errorRoute("Objeto OrderModel no proporcionado para $adminOrderDetails");
      case adminAccount:
        return MaterialPageRoute(builder: (_) => const AdminAccountScreen());

      default:
        // Si la ruta es desconocida y es la inicial, podría ir a AuthWrapper
        // Esto es un fallback si initialRoute no se maneja o es una ruta inválida.
        if (settings.name == null || settings.name == '/' || settings.name == AppRoutes.authWrapper) {
           return MaterialPageRoute(builder: (_) => const AuthWrapper());
        }
        return _errorRoute("Ruta no encontrada: ${settings.name}");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error de Ruta')),
        body: Center(child: Text('ERROR: $message')),
      );
    });
  }
}