import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.page.dart'; // Asumiendo que la ruta es correcta

class ProductListByCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListByCategoryScreen> createState() => _ProductListByCategoryScreenState();
}

class _ProductListByCategoryScreenState extends State<ProductListByCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductsByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
              ? Center(child: Text('Error: ${productProvider.errorMessage}'))
              : productProvider.categoryProducts.isEmpty
                  ? Center(child: Text('No hay productos en esta categoría: ${widget.categoryName}'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: productProvider.categoryProducts.length,
                      itemBuilder: (ctx, i) => ProductCard(product: productProvider.categoryProducts[i]),
                    ),
    );
  }
}