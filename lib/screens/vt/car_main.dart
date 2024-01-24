import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/widgets/appBar.dart';

import '../../colors.dart';


class CarMain extends StatefulWidget {
  const CarMain({Key? key}) : super(key: key);

  @override
  State<CarMain> createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  String otherWidgetText = 'Other Widget';
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  List<Map<String, LatLng>> items = [];
  final Location location = Location();
  late LatLng _center;

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
  } // 예시 데이터

  Future<void> _onMapCreated(GoogleMapController controller, LatLng departure,
      LatLng destination) async {
    mapController = controller;
    final markers =
        await mapService.createMarkers(controller, departure, destination);
    final currentLocation = await location.getLocation();
    final currentLatLng =
    LatLng(currentLocation.latitude!, currentLocation.longitude!);
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          alpha: 0.8,
          position: currentLatLng,
        ),
      );
    });





    // 카메라를 이동하여 LatLngBounds가 모두 보이도록 조절
    if (_center != departure) {
      // 카메라를 이동하여 LatLngBounds가 모두 보이도록 조절
      CameraUpdate u2 = CameraUpdate.newLatLngZoom(
        LatLng(
          (departure.latitude + destination.latitude) / 2,
          (departure.longitude + destination.longitude) / 2,
        ),
        13.0,
      );
      this.mapController.animateCamera(u2).then((void v) {
        mapController.moveCamera(u2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "PathPal",
      ),
      body: Column(
        children: [
          Container(
            height: 460, // 다른 위젯 의 높이 설정
            color: Colors.red, // 다른 위젯의 배경색 설정
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 13.0,
                  ),
                  markers: _markers,
                ),
                Positioned(
                  // 위치를 지정하여 버튼을 추가합니다.
                  bottom: 100,
                  right: 10,
                  child: FloatingActionButton(
                    foregroundColor: gray400,
                    backgroundColor: Colors.white,
                    onPressed: _currentLocation,
                    child: Icon(Icons.my_location),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))
                    ),
                  ),
                ),
              ],
            ), // 다른 위젯의 내용 설정
          ),
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                    onTap: () {
                      _onMapCreated(mapController, items[index]['출발지']!,
                          items[index]['도착지']!);
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

  void _currentLocation() async {
    Location location = Location();
    final currentLocation = await location.getLocation();

    setState(() {
      _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          position: _center,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          alpha: 0.8,
        ),
      );
    });

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 15.0,
      ),
    ));
  }
}
