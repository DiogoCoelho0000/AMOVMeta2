import 'location.dart';

class Contact {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? imagePath; // Caminho da imagem
  final String? photo; // Novo atributo opcional para armazenar o caminho da foto
  final String? birthDate;
  final List<LocationModel>? locations; // Adicionar lista de localizações


  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
    this.photo,
    this.birthDate,
    this.locations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imagePath': imagePath,
      'birthDate': birthDate,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map, {List<LocationModel>? locations}) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      imagePath: map['imagePath'],
      birthDate: map['birthDate'],
      locations: locations,
    );
  }
}

