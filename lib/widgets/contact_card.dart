import 'dart:io';
import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  ContactCard({
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),  // Espaçamento para o Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),  // Bordas arredondadas
      elevation: 4,  // Sombra leve
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: contact.imagePath != null
              ? FileImage(File(contact.imagePath!))
              : null,
          child: contact.imagePath == null ? Icon(Icons.person) : null,
        ),
        title: Text(
          contact.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${contact.phone}',
              style: TextStyle(fontSize: 16),
            ),
            if (contact.birthDate != null)
              Text(
                'Nascimento: ${contact.birthDate}',
                style: TextStyle(fontSize: 14),
              ),
            if (contact.latitude != null && contact.longitude != null)
              Text(
                'Localização: ${contact.latitude}, ${contact.longitude}',
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
