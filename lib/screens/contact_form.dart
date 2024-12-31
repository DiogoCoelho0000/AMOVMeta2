import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  ContactFormScreen({this.contact});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _name = '';
  String _email = '';
  String _phone = '';
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _name = widget.contact!.name;
      _email = widget.contact!.email;
      _phone = widget.contact!.phone;
      _imagePath = widget.contact!.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final contact = Contact(
        id: widget.contact?.id,
        name: _name,
        email: _email,
        phone: _phone,
        imagePath: _imagePath,
      );

      Navigator.pop(context, contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Novo Contato' : 'Editar Contato'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Exibir imagem ou botão para selecionar/tirar uma foto
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Escolher entre galeria ou câmera
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.photo),
                                title: Text('Escolher da Galeria'),
                                onTap: () {
                                  _pickImage();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Tirar Foto'),
                                onTap: () {
                                  _takePhoto();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    _imagePath != null ? FileImage(File(_imagePath!)) : null,
                    child: _imagePath == null
                        ? Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Digite o nome' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'E-mail'),
                onSaved: (value) => _email = value ?? '',
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) => value == null || value.isEmpty ? 'Digite o telefone' : null,
                onSaved: (value) => _phone = value!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveContact,
                child: Text('Salvar Contato'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
