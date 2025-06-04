import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/product_provider.dart'; // Para mostrar resultados
// import '../widgets/product_card.page.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Aquí usarías el ProductProvider para filtrar productos basados en searchQuery
    // o tendrías un método específico en el provider para la búsqueda.
    // final productProvider = Provider.of<ProductProvider>(context);
    // final searchResults = productProvider.searchProducts(searchQuery); // Método hipotético

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados para: "$searchQuery"'),
      ),
      body: const Center(
        child: Text('Contenido para Resultados de Búsqueda.'),
        // Ejemplo:
        // searchResults.isEmpty
        //     ? Center(child: Text('No se encontraron productos para "$searchQuery".'))
        //     : GridView.builder(
        //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           childAspectRatio: 2 / 3,
        //           crossAxisSpacing: 10,
        //           mainAxisSpacing: 10,
        //         ),
        //         itemCount: searchResults.length,
        //         itemBuilder: (ctx, i) => ProductCard(product: searchResults[i]),
        //       ),
      ),
    );
  }
}