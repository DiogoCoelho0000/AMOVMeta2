import 'package:location/location.dart';

class LocationHelper {
  static Future<LocationData?> getUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null; // Serviço não habilitado
      }
    }

    // Verifica se a permissão foi concedida
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null; // Permissão negada
      }
    }

    // Obtém os dados de localização
    locationData = await location.getLocation();
    return locationData;
  }
}
