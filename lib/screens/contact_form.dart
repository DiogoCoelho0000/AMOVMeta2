import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String? _birthDate; // Adicionando o campo de data de nascimento

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

  // Função para verificar as permissões de localização
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ative os serviços de localização.')),
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Permissão negada
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('As permissões de localização estão permanentemente negadas.')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  // Função para verificar permissões de câmera e armazenamento
  Future<void> _checkPermissions() async {
    // Verificar permissões (no Android, as permissões de câmera/galeria e localização precisam ser concedidas)
    if (Platform.isAndroid) {
      final cameraPermission = await Permission.camera.request();
      final storagePermission = await Permission.storage.request();
      final locationPermission = await Permission.location.request();

      if (cameraPermission.isDenied || storagePermission.isDenied || locationPermission.isDenied) {
        // Permissões negadas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissões de câmera, galeria e localização são necessárias.')),
        );
      }
    }
  }

  // Função para pegar a imagem da galeria
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print("Erro ao acessar a galeria: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar a galeria.')),
      );
    }
  }

  // Função para tirar a foto com a câmera
  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print("Erro ao acessar a câmera: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao acessar a câmera.')),
      );
    }
  }

  // Função para selecionar a data de nascimento
  Future<void> _selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthDate = "${pickedDate.toLocal()}".split(' ')[0]; // Formato YYYY-MM-DD
      });
    }
  }

  // Função para salvar o contato
  void _saveContact() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

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
              // Campo de data de nascimento
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