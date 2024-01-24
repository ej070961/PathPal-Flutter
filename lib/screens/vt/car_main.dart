import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/widgets/appBar.dart';

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
  @override
  void initState() {
     items = [
      {
        '출발지': LatLng(37.626000, 127.072000),
        '도착지': LatLng(37.628942, 127.071309),
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
  } // 예시 데이터



  Future<void> _onMapCreated(GoogleMapController controller, LatLng departure, LatLng destination) async {
    mapController = controller;
    final markers = await mapService.createMarkers(controller, departure, destination);
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  final LatLng _center = const LatLng(37.630103, 127.076493);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "PathPal",
      ),
      body: Column(
        children: [
          Container(
            height: 460, // 다른 위젯의 높이 설정
            color: Colors.red, // 다른 위젯의 배경색 설정
            child: GoogleMap(
              onMapCreated: (controller) => _onMapCreated(controller, items[0]['출발지']!, items[0]['도착지']!),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              markers: _markers,
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
                      _onMapCreated(mapController, items[index]['출발지']!, items[index]['도착지']!);
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
