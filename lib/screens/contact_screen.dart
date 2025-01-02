import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/contact_card.dart';
import 'contact_details.dart';
import '../models/contact.dart';
import 'contact_form.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // Lista de contatos mock para testar
  List<Contact> _contacts = [
    Contact(id: 1, name: 'João Silva', email: 'joao@email.com', phone: '123456789', birthDate: '1990-03-22'),
    Contact(id: 2, name: 'Maria Oliveira', email: 'maria@email.com', phone: '987654321', birthDate: '1985-07-15'),
  ];

  // Função para adicionar um novo contato
  void _addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
    });
  }

  // Função para editar um contato
  void _editContact(Contact contact, int index) {
    setState(() {
      _contacts[index] = contact;
    });
  }

  // Função para excluir um contato
  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  // Função para selecionar ou alterar uma foto para um contato
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
              // Editar contato
              String? updatedPhotoPath = contact.photo; // Manter foto atual, se não for alterada
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
                            setState(() {}); // Atualiza o estado para exibir a nova imagem no AlertDialog
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
                        // Data de Nascimento (apenas exibição)
                        Text(
                          'Data de Nascimento: ${contact.birthDate != null ? contact.birthDate : 'Não definida'}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx), // Cancelar edição
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Verifique se os campos obrigatórios estão preenchidos
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
                              photo: updatedPhotoPath, // Atualiza a foto, se necessário
                              birthDate: contact.birthDate, // Não altera a data de nascimento
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
                _editContact(result, index); // Atualiza contato na lista
              }
            },
            onDelete: () {
              _deleteContact(index); // Exclui o contato da lista
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Adicionar novo contato
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactFormScreen()),
          );
          if (result != null) {
            _addContact(result); // Adiciona o novo contato à lista
          }
        },
        child: Icon(Icons.add), // Ícone de "+", padrão para adicionar
        backgroundColor: Colors.blue, // Cor do botão
      ),
    );
  }
}
