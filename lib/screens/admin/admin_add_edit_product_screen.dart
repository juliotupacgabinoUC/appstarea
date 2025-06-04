import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/product_model.dart';
// import 'package:image_picker/image_picker.dart'; // Para seleccionar imagen
// import 'dart:io'; // Para File

class AdminAddEditProductScreen extends StatefulWidget {
  final ProductModel? product; // Si es null, es modo Agregar. Si no, modo Editar.

  const AdminAddEditProductScreen({super.key, this.product});

  @override
  State<AdminAddEditProductScreen> createState() => _AdminAddEditProductScreenState();
}

class _AdminAddEditProductScreenState extends State<AdminAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController; // O manejar carga de imagen
  late TextEditingController _categoryIdController;
  late TextEditingController _categoryNameController;
  late TextEditingController _stockController;

  bool _isAvailable = true;
  bool _isFeatured = false;
  bool _isLoading = false;
  // File? _pickedImage; // Para la imagen seleccionada

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
    _categoryIdController = TextEditingController(text: widget.product?.categoryId ?? '');
    _categoryNameController = TextEditingController(text: widget.product?.categoryName ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '0');
    _isAvailable = widget.product?.isAvailable ?? true;
    _isFeatured = widget.product?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _categoryIdController.dispose();
    _categoryNameController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImageFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 800);
  //   if (pickedImageFile != null) {
  //     setState(() {
  //       _pickedImage = File(pickedImageFile.path);
  //     });
  //     // Aquí podrías subir la imagen a Firebase Storage y obtener la URL
  //     // y luego setear _imageUrlController.text = uploadedUrl;
  //   }
  // }


  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    // Aquí, si _pickedImage no es null, deberías subirlo a Firebase Storage
    // y obtener la downloadURL para ponerla en _imageUrlController.text.
    // Por ahora, asumimos que la URL se ingresa manualmente o ya existe.
    // String imageUrl = _imageUrlController.text;
    // if (_pickedImage != null) {
    //   // imageUrl = await _uploadImageToStorage(_pickedImage!); // Función hipotética
    // }


    final productData = ProductModel(
      id: widget.product?.id, // Mantener el ID si se está editando
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0.0,
      imageUrl: _imageUrlController.text.trim(), // Debería ser la URL de Firebase Storage
      categoryId: _categoryIdController.text.trim(),
      categoryName: _categoryNameController.text.trim(),
      stock: int.tryParse(_stockController.text) ?? 0,
      isAvailable: _isAvailable,
      isFeatured: _isFeatured,
      createdAt: widget.product?.createdAt, // Mantener fecha original o null si es nuevo
    );

    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    bool success;
    if (widget.product == null) { // Modo Agregar
      success = await adminProvider.addProduct(productData);
    } else { // Modo Editar
      success = await adminProvider.updateProduct(widget.product!.id!, productData);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto ${widget.product == null ? "agregado" : "actualizado"} con éxito.')),
      );
      Navigator.of(context).pop(); // Volver a la lista de catálogo
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al ${widget.product == null ? "agregar" : "actualizar"} el producto.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Agregar Producto' : 'Editar Producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: _isLoading ? null : _saveProduct,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre del Producto', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Ingresa un nombre.' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty ? 'Ingresa una descripción.' : null,
                    ),
                    const SizedBox(height: 12),
                     Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'Precio', border: OutlineInputBorder(), prefixText: '\$ '),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Ingresa un precio.';
                              if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Ingresa un precio válido.';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                             validator: (value) {
                              if (value == null || value.isEmpty) return 'Ingresa el stock.';
                              if (int.tryParse(value) == null || int.parse(value) < 0) return 'Ingresa un stock válido.';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Widget para seleccionar/mostrar imagen
                    // _pickedImage != null
                    //     ? Image.file(_pickedImage!, height: 150)
                    //     : (widget.product?.imageUrl != null && widget.product!.imageUrl.isNotEmpty
                    //         ? Image.network(widget.product!.imageUrl, height: 150, errorBuilder: (_,__,___)=> Text('URL de imagen inválida'))
                    //         : Container(height: 150, width: double.infinity, decoration: BoxDecoration(border: Border.all(color: Colors.grey)), child: Center(child: Text('Previsualización Imagen')))),
                    // TextButton.icon(
                    //   icon: Icon(Icons.image_search_outlined),
                    //   label: Text(_pickedImage != null ? 'Cambiar Imagen' : 'Seleccionar Imagen'),
                    //   onPressed: _pickImage,
                    // ),
                    // const SizedBox(height: 12),
                    TextFormField( // Temporalmente, hasta implementar carga de imagen
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'URL de la Imagen (manual)', border: OutlineInputBorder()),
                       validator: (value) => value == null || value.isEmpty ? 'Ingresa una URL de imagen.' : null, // Opcional si se carga imagen
                    ),
                    const SizedBox(height: 12),
                     Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _categoryIdController,
                            decoration: const InputDecoration(labelText: 'ID Categoría', border: OutlineInputBorder()),
                            validator: (value) => value == null || value.isEmpty ? 'Ingresa un ID de categoría.' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                           child: TextFormField(
                            controller: _categoryNameController,
                            decoration: const InputDecoration(labelText: 'Nombre Categoría', border: OutlineInputBorder()),
                             validator: (value) => value == null || value.isEmpty ? 'Ingresa un nombre de categoría.' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Disponible'),
                      value: _isAvailable,
                      onChanged: (bool value) => setState(() => _isAvailable = value),
                    ),
                    SwitchListTile(
                      title: const Text('Destacado'),
                      value: _isFeatured,
                      onChanged: (bool value) => setState(() => _isFeatured = value),
                    ),
                     const SizedBox(height: 20),
                     ElevatedButton(
                       onPressed: _isLoading ? null : _saveProduct,
                       style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                       child: Text(widget.product == null ? 'Agregar Producto' : 'Guardar Cambios'),
                     )
                  ],
                ),
              ),
            ),
    );
  }
}