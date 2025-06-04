import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/category_provider.dart'; // Necesitarías este provider
// import 'product_list_by_category_screen.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final categoryProvider = Provider.of<CategoryProvider>(context); // Necesitarías un CategoryProvider
    // categoryProvider.fetchCategories(); // Llamar para cargar categorías

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: const Center(
        child: Text('Contenido para Lista de Categorías (requiere CategoryProvider).'),
        // Ejemplo:
        // categoryProvider.isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : categoryProvider.categories.isEmpty
        //         ? Center(child: Text('No hay categorías disponibles.'))
        //         : ListView.builder(
        //             itemCount: categoryProvider.categories.length,
        //             itemBuilder: (ctx, i) {
        //               final category = categoryProvider.categories[i];
        //               return ListTile(
        //                 title: Text(category.name),
        //                 onTap: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (_) => ProductListByCategoryScreen(categoryId: category.id, categoryName: category.name),
        //                     ),
        //                   );
        //                 },
        //               );
        //             },
        //           ),
      ),
    );
  }
}