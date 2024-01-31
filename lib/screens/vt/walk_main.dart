import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/widgets/appBar.dart';
import 'package:pathpal/widgets/google_map.dart';

import '../../service/map_service.dart';

class WalkMain extends StatefulWidget {
  const WalkMain({super.key});

  @override
  State<WalkMain> createState() => _WalkMainState();
}

class _WalkMainState extends State<WalkMain> {
  late GoogleMapController mapController;
  final MapService mapService = MapService();
  final Set<Marker> _markers = {};
  List<Map<String, LatLng>> items = [];
  LatLng? _center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "PathPal",
      ),
      body: Expanded(
        child: MyGoogleMap(
          center: _center,
          currentLocationFunction: _currentLocation,
          markers: _markers,
          onMapCreated: (controller) {
            mapController = controller;
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    items = [
      {
        '출발지': LatLng(37.626440, 127.074500),
        '도착지': LatLng(37.635812, 127.067820),
      },
      {
        '출발지': LatLng(37.626440, 127.074500),
        '도착지': LatLng(37.627097, 127.076425),
      },
      {
        '출발지': LatLng(37.626440, 127.074600),
        '도착지': LatLng(37.627097, 127.076425),
      },
    ];
    _center = const LatLng(37.6300, 127.0764);
  }

  void _currentLocation() async {
    final currentLocation = await mapService.getCurrentLocation();

    setState(() {
      _markers.remove(_center);
      _center = currentLocation;
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          position: _center!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          alpha: 0.8,
        ),
      );
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _center!,
        zoom: 15.0,
      ),
    ));
  }

  Future<void> _onMapCreated(GoogleMapController controller, LatLng departure,
      LatLng destination) async {
    mapController = controller;

    final markers = await mapService.createMarkers(departure, destination);
    final currentLocation = await mapService.getCurrentLocation();

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          alpha: 0.8,
          position: currentLocation,
        ),
      );
    });

    mapService.moveCamera(controller, departure, destination);
  }
}
