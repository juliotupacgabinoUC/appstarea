// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';

// 👇 CORRECCIÓN DE RUTAS DE IMPORTACIÓN AQUÍ 👇
import '../widgets/order_summary.page.dart';
import '../widgets/custom_button.page.dart';
import '../widgets/loading_indicator.page.dart';
import '../widgets/error_dialog.page.dart';      // Ahora apunta a widgets
import '../widgets/snackbar_helper.page.dart';  // Ahora apunta a widgets

// Si usas rutas nombradas, podrías necesitar AppRoutes
// import '../routes.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  // static const routeName = AppRoutes.checkout; // Si está definido en AppRoutes

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _shippingAddress = '';
  String _paymentMethod = 'Tarjeta de Crédito'; // Valor inicial
  bool _isLoading = false; // Estado de carga local para esta pantalla

  final List<String> _paymentMethods = [
    'Tarjeta de Crédito',
    'PayPal',
    'Transferencia Bancaria',
  ];

  Future<void> _placeOrder() async {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticatedAndReady) {
      // Uso de SnackbarHelper con la ruta ajustada
      SnackbarHelper.showErrorSnackbar(context, 'Debes iniciar sesión y tener tu perfil cargado para realizar un pedido.');
      if (!authProvider.isFirebaseAuthenticated) {
        // Considera navegar a la pantalla de login si es apropiado
        // Navigator.of(context).pushNamed(AppRoutes.login);
      }
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    final String? userId = authProvider.userProfile?.uid;

    if (userId == null) {
        if (mounted) {
            setState(() => _isLoading = false);
            // Uso de ErrorDialog con la ruta ajustada
            ErrorDialog.show(
                context: context,
                title: 'Error de Usuario',
                message: 'No se pudo obtener la información del usuario para realizar el pedido.',
            );
        }
        return;
    }

    bool success = false;
    try {
      success = await orderProvider.placeOrder(
        cartItems: cartProvider.items.values.toList(),
        totalAmount: cartProvider.totalAmount,
        shippingAddress: _shippingAddress,
        paymentMethod: _paymentMethod,
      );

      if (success && mounted) {
        cartProvider.clearCart();
        SnackbarHelper.showSuccessSnackbar(context, '¡Pedido realizado con éxito!');
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (!success && mounted && orderProvider.errorMessage != null) {
        ErrorDialog.show(
          context: context,
          title: 'Error al Realizar Pedido',
          message: orderProvider.errorMessage!,
        );
      } else if (!success && mounted) {
         ErrorDialog.show(
          context: context,
          title: 'Error al Realizar Pedido',
          message: 'Ocurrió un error desconocido al procesar tu pedido.',
        );
      }
    } catch (e) {
        if (mounted) {
            ErrorDialog.show(
                context: context,
                title: 'Error Inesperado',
                message: 'Ocurrió un error: ${e.toString()}',
            );
        }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = Provider.of<CartProvider>(context).itemCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Compra'),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Procesando tu pedido...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const OrderSummary(),
                    const SizedBox(height: 24),

                    Text('Dirección de Envío', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Dirección completa',
                        hintText: 'Calle, número, colonia, ciudad, estado, C.P.',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_shipping_outlined),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, ingresa tu dirección de envío.';
                        }
                        if (value.trim().length < 10) {
                           return 'La dirección parece demasiado corta.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _shippingAddress = value!;
                      },
                    ),
                    const SizedBox(height: 24),

                    Text('Método de Pago', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payment_outlined),
                      ),
                      value: _paymentMethod,
                      items: _paymentMethods.map((String method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _paymentMethod = newValue;
                          });
                        }
                      },
                      validator: (value) => value == null ? 'Selecciona un método de pago' : null,
                    ),
                    const SizedBox(height: 32),

                    CustomButton(
                      text: 'Realizar Pedido',
                      onPressed: cartItemCount == 0 ? null : _placeOrder,
                      isLoading: _isLoading,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}