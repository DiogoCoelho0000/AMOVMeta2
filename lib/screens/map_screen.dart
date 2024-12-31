import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/database_helper.dart';
import '../models/contact.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  //final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Contact> _contacts = [];
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    //final contacts = await _dbHelper.getContacts();
    setState(() {
      //_contacts = contacts.where((c) => c.latitude != null && c.longitude != null).toList();
      _markers = _contacts.map((contact) {
        return Marker(
          markerId: MarkerId(contact.id.toString()),
          //position: LatLng(contact.latitude!, contact.longitude!),
          infoWindow: InfoWindow(
            title: contact.name,
            snippet: contact.phone,
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Contatos')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Altere para uma localização padrão
          zoom: 2,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
