import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos un ListView para que el contenido sea desplazable si excede la pantalla
    return ListView(
      children: [
        // 1. Sección de Bienvenida
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '¡Bienvenido de vuelta!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 2. Banner Principal con una Card
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Usamos una imagen de placeholder. Puedes cambiar la URL.
                Image.network(
                  'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?q=80&w=2070&auto=format&fit=crop',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Contenedor para el texto sobre la imagen
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    ),
                  ),
                  child: const Text(
                    'Ofertas de Temporada',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),

        // 3. Sección de Acciones Rápidas
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Acciones Rápidas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 4. Cuadrícula (Grid) de acciones
        GridView.count(
          // Importante: deshabilita el scroll del GridView y ajústalo al contenido
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, // 2 columnas
          padding: const EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0, // Espacio horizontal
          mainAxisSpacing: 16.0,  // Espacio vertical
          childAspectRatio: 3 / 2, // Proporción de las tarjetas
          children: [
            _buildActionCard(
              context,
              icon: Icons.category,
              title: 'Categorías',
              color: Colors.blue,
            ),
            _buildActionCard(
              context,
              icon: Icons.star_border,
              title: 'Favoritos',
              color: Colors.orange,
            ),
            _buildActionCard(
              context,
              icon: Icons.history,
              title: 'Historial',
              color: Colors.green,
            ),
            _buildActionCard(
              context,
              icon: Icons.local_offer,
              title: 'Promociones',
              color: Colors.red,
            ),
          ],
        )
      ],
    );
  }

  // Widget helper para construir cada tarjeta de acción
  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required Color color}) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Lógica para cuando se presiona la tarjeta
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Acción: $title')),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}