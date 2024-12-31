class Location {
  double latitude;
  double longitude;

  Location(this.latitude, this.longitude);

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Location fromMap(Map<String, dynamic> map) {
    return Location(
      map['latitude'],
      map['longitude'],
    );
  }
}