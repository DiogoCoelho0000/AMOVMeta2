import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactDetails extends StatefulWidget {
  final Contact? contact;  // Contato a ser editado, se houver

  ContactDetails({this.contact});

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String? _birthDate;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _name = widget.contact!.name;
      _email = widget.contact!.email;
      _phone = widget.contact!.phone;
      _birthDate = widget.contact!.birthDate; // Carregando a data de nascimento
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final contact = Contact(
        id: widget.contact!.id, // Mantém o ID se for edição
        name: _name,
        email: _email,
        phone: _phone,
        birthDate: _birthDate, // Salvando a data de nascimento
      );

      Navigator.pop(context, contact); // Retorna o contato criado ou editado
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
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Digite o nome' : null,
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
                validator: (value) =>
                value == null || value.isEmpty ? 'Digite o telefone' : null,
                onSaved: (value) => _phone = value!,
              ),
              TextFormField(
                initialValue: _birthDate,
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                onSaved: (value) => _birthDate = value,
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
