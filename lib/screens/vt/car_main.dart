import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/widgets/appBar.dart';

class CarMain extends StatefulWidget {
  const CarMain({Key? key}) : super(key: key);

  @override
  _CarMainState createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  late GoogleMapController mapController;
  final LatLng _startLocation = const LatLng(45.521563, -122.677433);
  final LatLng _endLocation = const LatLng(45.510767, -122.665043);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('startLocation'),
          position: _startLocation,
          infoWindow: const InfoWindow(title: 'Start Location')));
      _markers.add(Marker(
          markerId: const MarkerId('endLocation'),
          position: _endLocation,
          infoWindow: const InfoWindow(title: 'End Location')));
    });
  }

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'PathPal'),
      body: Column(
        children: [
          Container(
            height: 460,
            color: Colors.red,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _startLocation,
                zoom: 11.0,
              ),
              markers: _markers,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                    onTap: () {
                      setState(() {
                        // 리스트 아이템이 눌렸을 때 Other Widget의 Text 업데이트
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
