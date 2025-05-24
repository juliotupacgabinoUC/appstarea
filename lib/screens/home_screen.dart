// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
// 1. Importa las nuevas páginas que creaste
import '../../pages/cart_page.dart';
import '../../pages/home_page.dart';
import '../../pages/account_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  // 2. Reemplaza los Text widgets con tus nuevas páginas
  static const List<Widget> _widgetOptions = <Widget>[
    CartPage(),
    HomePage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cambiamos el título del AppBar dependiendo de la página seleccionada
    String title;
    switch (_selectedIndex) {
      case 0:
        title = 'Carrito';
        break;
      case 1:
        title = 'Inicio';
        break;
      case 2:
        title = 'Mi Cuenta';
        break;
      default:
        title = 'App';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cuenta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}