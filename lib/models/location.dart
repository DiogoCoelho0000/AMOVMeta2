class LocationModel {
  final double latitude;
  final double longitude;
  final String? contactId; // Identificador opcional do contato

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.contactId,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'contactId': contactId, // Adicionado no mapeamento
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'],
      longitude: map['longitude'],
      contactId: map['contactId'], // Adicionado na criação da instância
    );
  }
}
