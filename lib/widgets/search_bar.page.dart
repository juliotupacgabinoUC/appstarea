import 'package:flutter/material.dart';

class CommonSearchBar extends StatefulWidget {
  final Function(String) onSearchSubmitted;
  final String? initialText;
  final String hintText;

  const CommonSearchBar({
    super.key,
    required this.onSearchSubmitted,
    this.initialText,
    this.hintText = 'Buscar productos...',
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchSubmitted(''); // Opcional: buscar con string vacío o manejar diferente
                  },
                )
              : null,
        ),
        onSubmitted: widget.onSearchSubmitted,
        onChanged: (text) {
          // Para búsquedas en tiempo real, podrías llamar a onSearchSubmitted aquí
          // con un debounce para no hacer demasiadas llamadas.
          // Por ahora, solo actualiza el estado del ícono de limpiar.
          setState(() {});
        },
      ),
    );
  }
}