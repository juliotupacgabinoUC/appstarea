// lib/widgets/error_dialog.page.dart
import 'package:flutter/material.dart';

class ErrorDialog { // <-- Nombre de la clase
  static Future<void> show({ // <-- Método estático llamado 'show'
    required BuildContext context,
    String title = 'Se produjo un error', // Título por defecto
    required String message,
    String buttonText = 'ENTENDIDO', // Texto del botón por defecto
    VoidCallback? onButtonPressed,
  }) async {
    if (!context.mounted) return; // Buena práctica: verificar si el contexto sigue montado
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar el botón para cerrar
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(dialogContext).colorScheme.error)),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText, style: TextStyle(color: Theme.of(dialogContext).primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cerrar el diálogo
                onButtonPressed?.call(); // Ejecutar callback adicional si existe
              },
            ),
          ],
        );
      },
    );
  }
}