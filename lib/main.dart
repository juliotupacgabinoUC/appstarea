import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importa la pantalla con el menú

void main() {
  // La función principal que inicia la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp es el widget raíz que configura tu aplicación
    return MaterialApp(
      // Desactiva la cinta de "Debug" en la esquina superior derecha
      debugShowCheckedModeBanner: false, 
      
      title: 'Demo App',
      
      // Define el tema visual de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // La pantalla de inicio de la aplicación.
      // Aquí conectamos todo nuestro trabajo.
      home: const HomeScreen(), 
    );
  }
}