import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/map_screen.dart';          // Tela com o mapa
import 'screens/contact_form.dart';        // Tela para adicionar contactos

void main() {
  runApp(ContactsApp());
}

class ContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho Pratico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/contacts': (context) => ContactsListScreen(), // Tela com lista de contactos
        //'/map': (context) => MapScreen(),               // Tela com o mapa
        //'/add_contact': (context) => ContactFormScreen(), // Tela para adicionar contacto
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
