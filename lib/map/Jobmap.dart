// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(Jobmap());
}

class Jobmap extends StatefulWidget {
  @override
  State<Jobmap> createState() => _JobmapState();
}

class _JobmapState extends State<Jobmap> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(10.8049633, 106.6348333), zoom: 14);
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Bản đồ'),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosion();
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 16)));
          markers.clear();
          markers.add(Marker(markerId: const MarkerId('Vi tri hien tai'),position: LatLng(position.latitude,position.longitude)));
          setState(() {

          });
        },
        label: const Text("Vị trí của bạn"),
        icon: Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> _determinePosion() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      return Future.error('Vi tri cua ban chua bat');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Tu choi truy cap vi tri");
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Luon tu choi truy cap vi tri ');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
