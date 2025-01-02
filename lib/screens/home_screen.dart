import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem-vindo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo à aplicação de contatos!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/contacts'),
              child: Text('Ver Contatos'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/map'),
              child: Text('Ver Mapa (Estático)'),
            ),
            ElevatedButton(
              onPressed: () async {
                final locationData = await getUserLocation();
                if (locationData != null) {
                  Navigator.pushNamed(
                    context,
                    '/map',
                    arguments: {
                      'latitude': locationData.latitude!,
                      'longitude': locationData.longitude!,
                    },
                  );
                } else {
                  print("Erro ao obter localização");
                }
              },
              child: Text('Ver Localização Atual no Mapa'),
            ),

          ],
        ),
      ),
    );
  }

  /// Função para obter a localização atual do usuário
  Future<LocationData?> getUserLocation() async {
    try {
      final location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return null;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return null;
      }

      final locationData = await location.getLocation();
      return locationData;
    } catch (e) {
      print('Erro ao obter localização: $e');
      return null;
    }
  }
}
