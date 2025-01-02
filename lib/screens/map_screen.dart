import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Location _location;
  late Stream<LocationData> _locationStream;

  // Inicializando as variáveis com valores padrão
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _isLocationReady = false;  // Controla se a localização foi carregada

  @override
  void initState() {
    super.initState();
    _location = Location();

    // Obter a localização inicial (caso o usuário não tenha dado permissão para atualizações contínuas)
    _getInitialLocation();

    // Configurar o stream para obter atualizações contínuas de localização
    _locationStream = _location.onLocationChanged;

    // Escutar o stream para atualizações contínuas de localização
    _locationStream.listen((LocationData currentLocation) {
      setState(() {
        _latitude = currentLocation.latitude!;
        _longitude = currentLocation.longitude!;
      });
    });
  }

  // Função para obter a localização inicial (caso necessário)
  Future<void> _getInitialLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _latitude = locationData.latitude!;
        _longitude = locationData.longitude!;
        _isLocationReady = true;  // A localização foi carregada com sucesso
      });
    } catch (e) {
      print("Erro ao obter a localização inicial: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Garantir que a localização foi carregada antes de renderizar o mapa
    if (!_isLocationReady) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mapa - OpenStreetMap'),
        ),
        body: Center(
          child: CircularProgressIndicator(),  // Exibe um indicador de carregamento
        ),
      );
    }

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
              Marker(
                point: LatLng(_latitude, _longitude),
                width: 80.0,
                height: 80.0,
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
