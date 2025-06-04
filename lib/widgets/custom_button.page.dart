// lib/widgets/custom_button.page.dart (o la ruta que estés usando)
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color; // Color de fondo personalizado
  final Color? textColor; // Color de texto personalizado
  final double? width;
  final double height;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height = 50.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar el color de fondo efectivo
    final ThemeData theme = Theme.of(context);
    final Color effectiveBackgroundColor = color ?? theme.primaryColor;

    // ✨ CORRECCIÓN AQUÍ: Usar colorScheme.onPrimary o estimar brillo ✨
    // Opción 1: Usar el color "onPrimary" del esquema de colores del tema (Recomendado)
    final Color defaultTextColorOnPrimary = theme.colorScheme.onPrimary;

    // Opción 2: Estimar el brillo del color de fondo para elegir blanco o negro
    // final Brightness estimatedBrightness = ThemeData.estimateBrightnessForColor(effectiveBackgroundColor);
    // final Color alternativeDefaultTextColor = estimatedBrightness == Brightness.dark ? Colors.white : Colors.black;

    // Usar el textColor personalizado si se proporciona, si no, el color del tema
    final Color effectiveTextColor = textColor ?? defaultTextColorOnPrimary; // Usando Opción 1

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor, // Color del texto y del indicador de progreso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          disabledBackgroundColor: effectiveBackgroundColor.withOpacity(0.5),
          disabledForegroundColor: effectiveTextColor.withOpacity(0.7),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // El color del texto ya se define en 'foregroundColor' del ElevatedButton.styleFrom
                    // No es necesario definirlo explícitamente aquí a menos que quieras una lógica diferente
                    // para el texto cuando está deshabilitado que no cubra 'disabledForegroundColor'.
                    // color: onPressed == null || isLoading ? effectiveTextColor.withOpacity(0.7) : effectiveTextColor,
                ),
              ),
      ),
    );
  }
}