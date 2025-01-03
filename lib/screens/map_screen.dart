import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';

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
    _getInitialLocation();

    // Carregar localizações armazenadas em JSON
    carregarLocalizacoes().then((loadedLocations) {
      setState(() {
        localizacoes = loadedLocations;
      });
    });

    _locationStream = _location.onLocationChanged;

    // Escutar as atualizações da localização
    _locationStream.listen((LocationData currentLocation) {
      setState(() {
        _latitude = currentLocation.latitude!;
        _longitude = currentLocation.longitude!;
        adicionarLocalizacao(_latitude, _longitude, contactId: ''); // Armazenar a localização
      });
    });
  }

  Future<void> salvarLocalizacoes(List<LocationModel> localizacoes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = localizacoes.map((loc) => jsonEncode(loc.toMap())).toList();
    await prefs.setStringList('localizacoes', jsonList);
  }

  Future<List<LocationModel>> carregarLocalizacoes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('localizacoes') ?? [];
    return jsonList.map((json) {
      try {
        return LocationModel.fromMap(jsonDecode(json));
      } catch (e) {
        print("Erro ao carregar localização: $e");
        return null;
      }
    }).whereType<LocationModel>().toList();
  }
  
  void associarLocalizacaoAoContato(String contactId, double latitude, double longitude) {
    adicionarLocalizacao(latitude, longitude, contactId: contactId);
  }

  // Função para obter a localização inicial
  Future<void> _getInitialLocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      // Verificar se o serviço está habilitado
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          throw Exception("Serviço de localização não habilitado.");
        }
      }

      // Verificar permissões
      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          throw Exception("Permissão de localização negada.");
        }
      }

      // Obter localização inicial
      final locationData = await _location.getLocation();
      setState(() {
        _latitude = locationData.latitude!;
        _longitude = locationData.longitude!;
        _isLocationReady = true;
      });
    } catch (e) {
      print("Erro ao obter a localização inicial: $e");
    }
  }

  // Função para armazenar a localização na lista
  void adicionarLocalizacao(double latitude, double longitude, {required String contactId}) {
    final novaLocalizacao = LocationModel(latitude: latitude, longitude: longitude);
    setState(() {
      localizacoes.add(novaLocalizacao);

      // Limitar a 100 localizações
      if (localizacoes.length > 10) {
        localizacoes.removeAt(0);
      }
    });
    salvarLocalizacoes(localizacoes);
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
          child:CircularProgressIndicator(),
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
              // Marcador da localização atual
              Marker(
                point: LatLng(_latitude, _longitude),
                width: 80.0,
                height: 80.0,
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              // Marcadores para localizações de contatos
              ...localizacoes.where((loc) => loc.contactId != null).map((loc) {
                return Marker(
                  point: LatLng(loc.latitude, loc.longitude),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 40,
                  ),
                );
              }).toList(),
              // Marcadores para outras localizações
              ...localizacoes.where((loc) => loc.contactId == null).map((loc) {
                return Marker(
                  point: LatLng(loc.latitude, loc.longitude),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
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
