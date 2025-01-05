import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/contact.dart';
import '../utils/FileStorage_helper.dart';

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
  String? _birthDate;

  @override
  void initState() {
    super.initState();
    _checkPermissions();

    if (widget.contact != null) {
      _name = widget.contact!.name;
      _email = widget.contact!.email;
      _phone = widget.contact!.phone;
      _imagePath = widget.contact!.imagePath;
      _birthDate = widget.contact!.birthDate;
    }
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.location,
    ].request();

    if (statuses.values.any((status) => !status.isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissões de câmera, galeria e localização são necessárias.')),
      );
    }
  }

  Future<void> _pickImage({required ImageSource source}) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhuma imagem selecionada.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar a ${source == ImageSource.gallery ? "galeria" : "câmera"}.')),
      );
    }
  }

  Future<void> _selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ative os serviços de localização.')),
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissões de localização negadas.')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _saveContact() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Obtendo localização...'), duration: Duration(seconds: 2)),
      );

      final position = await _getCurrentLocation();
      if (position == null) return;

      final contact = Contact(
        id: widget.contact?.id,
        name: _name,
        email: _email,
        phone: _phone,
        imagePath: _imagePath,
        birthDate: _birthDate,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      List<Contact> contatos = await FileStorageHelper().carregarContatos();
      if (widget.contact == null) {
        contatos.add(contact);
      } else {
        int index = contatos.indexWhere((c) => c.id == widget.contact?.id);
        if (index != -1) {
          contatos[index] = contact;
        }
      }

      await FileStorageHelper().salvarContatos(contatos);

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
              GestureDetector(
                onTap: () async {
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
                                _pickImage(source: ImageSource.gallery);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Tirar Foto'),
                              onTap: () {
                                _pickImage(source: ImageSource.camera);
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
                  backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null ? Icon(Icons.camera_alt, size: 40) : null,
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
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite o e-mail';
                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regex.hasMatch(value)) return 'Digite um e-mail válido';
                  return null;
                },
                onSaved: (value) => _email = value ?? '',
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) => value == null || value.isEmpty ? 'Digite o telefone' : null,
                onSaved: (value) => _phone = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _birthDate,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  hintText: 'Selecione a data',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectBirthDate,
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
