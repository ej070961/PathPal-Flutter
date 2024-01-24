import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarMain extends StatefulWidget {
  const CarMain({Key? key}) : super(key: key);

  @override
  State<CarMain> createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  String otherWidgetText = 'Other Widget';
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PathPal"),
      ),
      body: Column(
        children: [
          Container(
            height: 460,  // 다른 위젯의 높이 설정
            color: Colors.red,  // 다른 위젯의 배경색 설정
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),  // 다른 위젯의 내용 설정
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
                        otherWidgetText = 'Item $index was tapped';  // 리스트 아이템이 눌렸을 때 Other Widget의 Text 업데이트
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
