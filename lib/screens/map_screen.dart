import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Location _location;
  late Stream<LocationData> _locationStream;
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _isLocationReady = false;

  // Lista para armazenar as localizações
  List<LocationModel> localizacoes = [];

  @override
  void initState() {
    super.initState();
    _location = Location();
    _getInitialLocation();  // Obter a localização inicial
    _locationStream = _location.onLocationChanged;  // Stream para atualizar a localização continuamente

    // Escutar as atualizações da localização
    _locationStream.listen((LocationData currentLocation) {
      setState(() {
        _latitude = currentLocation.latitude!;
        _longitude = currentLocation.longitude!;
        adicionarLocalizacao(_latitude, _longitude);  // Armazenar a localização
      });
    });
  }

  // Função para obter a localização inicial
  Future<void> _getInitialLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _latitude = locationData.latitude!;
        _longitude = locationData.longitude!;
        _isLocationReady = true;  // A localização inicial foi obtida
      });
    } catch (e) {
      print("Erro ao obter a localização inicial: $e");
    }
  }

  // Função para armazenar a localização na lista
  void adicionarLocalizacao(double latitude, double longitude) {
    final novaLocalizacao = LocationModel(latitude: latitude, longitude: longitude);
    localizacoes.add(novaLocalizacao);  // Armazenando na lista
    print("Localização armazenada: $latitude, $longitude");
  }

  @override
  Widget build(BuildContext context) {
    // Exibir indicador de carregamento enquanto a localização não está pronta
    if (!_isLocationReady) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mapa - OpenStreetMap'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Exibição do mapa com a localização atual e histórico
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa - OpenStreetMap'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(_latitude, _longitude),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // Marcador para a localização atual
              Marker(
                point: LatLng(_latitude, _longitude),
                width: 80.0,
                height: 80.0,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ),
              // Marcadores para o histórico de localizações
              ...localizacoes.map((localizacao) {
                return Marker(
                  point: LatLng(localizacao.latitude, localizacao.longitude),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
