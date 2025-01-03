import 'location.dart';

class Contact {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? imagePath;
  //final String? photo; // Novo atributo opcional para armazenar o caminho da foto
  final String? birthDate; // Data de nascimento
  final List<LocationModel>? locations; // Lista de localizações

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
    //this.photo,
    this.birthDate,
    this.locations,
  });

  // Método para converter o objeto em Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imagePath': imagePath,
      //'photo': photo, // Salvando o caminho da foto
      'birthDate': birthDate, // Salvando a data de nascimento
      'locations': locations?.map((location) => location.toMap()).toList(), // Serializando localizações
    };
  }

  // Método para criar um objeto a partir de um Map
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      imagePath: map['imagePath'],
      //photo: map['photo'], // Recuperando o caminho da foto
      birthDate: map['birthDate'], // Recuperando a data de nascimento
      locations: map['locations'] != null
          ? (map['locations'] as List).map((e) => LocationModel.fromMap(e)).toList()
          : null, // Desserializando localizações
    );
  }

  // Método para converter o objeto em JSON
  Map<String, dynamic> toJson() {
    return toMap(); // O mesmo que o método toMap
  }

  // Método para criar um objeto a partir de JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact.fromMap(json);
  }
}
