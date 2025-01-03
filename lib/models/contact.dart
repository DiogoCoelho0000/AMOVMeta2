class Contact {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? imagePath;
  final String? birthDate;
  final double? latitude; // Nova propriedade
  final double? longitude; // Nova propriedade

  Contact({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
    this.birthDate,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'imagePath': imagePath,
    'birthDate': birthDate,
    'latitude': latitude,
    'longitude': longitude,
  };

  static Contact fromJson(Map<String, dynamic> json) => Contact(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    imagePath: json['imagePath'],
    birthDate: json['birthDate'],
    latitude: json['latitude'],
    longitude: json['longitude'],
  );
}
