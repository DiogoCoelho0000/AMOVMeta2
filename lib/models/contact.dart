class Contact {
  int? id;
  String name;
  String email;
  String phone;
  String? birthDate;
  String? imagePath;
  List<Location>? locations;

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.birthDate,
    this.imagePath,
    this.locations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'birthDate': birthDate,
      'imagePath': imagePath,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      birthDate: map['birthDate'],
      imagePath: map['imagePath'],
    );
  }
}

class Location {
  double latitude;
  double longitude;

  Location(this.latitude, this.longitude);
}