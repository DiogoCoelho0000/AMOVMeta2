import 'location.dart';

class Contact {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? imagePath;
  final String? photo; // Novo atributo opcional para armazenar o caminho da foto
  final String? birthDate; // Data de nascimento
  final List<LocationModel>? locations; // Lista de localizações

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
    this.photo,
    this.birthDate,  // Incluindo o campo de data de nascimento
    this.locations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imagePath': imagePath,
      'birthDate': birthDate,  // Salvando a data de nascimento
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map, {List<LocationModel>? locations}) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      imagePath: map['imagePath'],
      birthDate: map['birthDate'],  // Recuperando a data de nascimento
      locations: locations,
    );
  }
}
