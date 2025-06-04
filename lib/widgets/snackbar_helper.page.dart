import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSuccessSnackbar(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.green);
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.red);
  }

  static void showInfoSnackbar(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.blue);
  }

  static void showWarningSnackbar(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.orange);
  }

  static void _showSnackbar(BuildContext context, String message, Color backgroundColor) {
    if (!context.mounted) return; // Verificar si el contexto sigue montado
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Ocultar snackbar anterior si existe
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating, // O SnackBarBehavior.fixed
        duration: const Duration(seconds: 3), // Duración estándar
      ),
    );
  }
}

// Ejemplo de uso:
// SnackbarHelper.showSuccessSnackbar(context, "Operación completada exitosamente!");
// SnackbarHelper.showErrorSnackbar(context, "Ocurrió un error inesperado.");