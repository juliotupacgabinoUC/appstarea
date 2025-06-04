// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../routes.dart'; // Para usar AppRoutes

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // static const routeName = AppRoutes.welcome; // Si la defines en AppRoutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Aquí podrías poner el logo de tu app
              FlutterLogo(size: 100, textColor: Theme.of(context).primaryColor),
              const SizedBox(height: 40),
              Text(
                'Bienvenido a la Tienda de Figuras 3D',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: const Text('Ingresar como Cliente'),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                 style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.adminLogin);
                },
                child: const Text('Ingresar como Administrador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}