import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/contact_card.dart';
import '../models/contact.dart';
import 'contact_form.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Carregar contatos salvos
  }

  /// Carregar contatos do SharedPreferences
  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsString = prefs.getString('contacts');
    if (contactsString != null) {
      List<dynamic> decodedContacts = jsonDecode(contactsString);
      setState(() {
        _contacts = decodedContacts.map((e) => Contact.fromJson(e)).toList();
      });
    }
  }

  /// Salvar contatos no SharedPreferences
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedContacts = jsonEncode(_contacts.map((e) => e.toJson()).toList());
    await prefs.setString('contacts', encodedContacts);
  }

  /// Adicionar um novo contato
  void _addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
      if (_contacts.length > 10) {
        _contacts.removeAt(0); // Remove o contato mais antigo (primeiro da lista)
      }
    });
    _saveContacts(); // Salvar após adicionar
  }


  /// Editar um contato
  void _editContact(Contact contact, int index) {
    setState(() {
      _contacts.removeAt(index); // Remove o contato da posição atual
      _contacts.add(contact); // Adiciona o contato ao final da lista
      if (_contacts.length > 10) {
        _contacts.removeAt(0); // Remove o mais antigo se ultrapassar 10
      }
    });
    _saveContacts(); // Salva os contatos atualizados
  }


  /// Excluir um contato
  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
    _saveContacts(); // Salvar após excluir
  }

  /// Selecionar ou alterar a foto do contato
  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: _contacts.isEmpty
          ? Center(child: Text('Nenhum contato encontrado.'))
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ContactCard(
            contact: contact,
            onEdit: () async {
              String? updatedPhotoPath = contact.imagePath;
              final result = await showDialog<Contact>(
                context: context,
                builder: (ctx) {
                  String name = contact.name;
                  String email = contact.email;
                  String phone = contact.phone;

                  return AlertDialog(
                    title: Text('Editar Contato'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            updatedPhotoPath = await _pickImage();
                            setState(() {}); // Atualiza a imagem no AlertDialog
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: updatedPhotoPath != null
                                ? FileImage(File(updatedPhotoPath!))
                                : null,
                            child: updatedPhotoPath == null
                                ? Icon(Icons.person, size: 40)
                                : null,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: TextEditingController(text: name),
                          onChanged: (value) => name = value,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: TextEditingController(text: email),
                          onChanged: (value) => email = value,
                          decoration: InputDecoration(labelText: 'E-mail'),
                        ),
                        TextField(
                          controller: TextEditingController(text: phone),
                          onChanged: (value) => phone = value,
                          decoration: InputDecoration(labelText: 'Telefone'),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Data de Nascimento: ${contact.birthDate ?? 'Não definida'}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text('Preencha todos os campos!')),
                            );
                            return;
                          }

                          Navigator.pop(
                            ctx,
                            Contact(
                              id: contact.id,
                              name: name,
                              email: email,
                              phone: phone,
                              imagePath: updatedPhotoPath,
                              birthDate: contact.birthDate,
                            ),
                          );
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  );
                },
              );

              if (result != null) {
                _editContact(result, index);
              }
            },
            onDelete: () {
              _deleteContact(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactFormScreen()),
          );
          if (result != null) {
            _addContact(result);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
