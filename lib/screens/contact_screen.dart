import 'dart:io';

import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../utils/database_helper.dart';

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<Contact> contacts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final fetchedContacts = await _dbHelper.getContacts();
    setState(() {
      contacts = fetchedContacts;
    });
  }

  /*Future<void> _deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    _loadContacts();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contactos'),
      ),
      body: contacts.isEmpty
          ? Center(
        child: Text(
          'Nenhum contacto encontrado.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: contact.imagePath != null
                ? CircleAvatar(
              backgroundImage: FileImage(File(contact.imagePath!)),
            )
                : CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            onTap: () {
              // Navegar para detalhes do contato
              Navigator.pushNamed(context, '/contact_details', arguments: contact);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Excluir o contato
                //_deleteContact(contact.id!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de adicionar contato
          Navigator.pushNamed(context, '/add_contact').then((_) => _loadContacts());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
