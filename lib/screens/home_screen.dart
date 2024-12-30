import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo à aplicação de contactos!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a lista de contactos
                Navigator.pushNamed(context, '/contacts');
              },
              child: Text('Ver Lista de Contactos'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navegar para outra funcionalidade (ex.: mapa)
                Navigator.pushNamed(context, '/map');
              },
              child: Text('Ver Localizações'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navegar para a funcionalidade de adicionar contacto
                Navigator.pushNamed(context, '/add_contact');
              },
              child: Text('Adicionar Novo Contacto'),
            ),
          ],
        ),
      ),
    );
  }
}
