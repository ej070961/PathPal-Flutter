import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/widgets/appBar.dart';

import '../../colors.dart';
import '../../widgets/google_map.dart';

class CarMain extends StatefulWidget {
  const CarMain({Key? key}) : super(key: key);

  @override
  State<CarMain> createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  List<Map<String, LatLng>> items = [];
  LatLng? _center;

  static const String basicProfileImagePath = 'assets/images/basic-profile.png';
  static const String circleIconImagePath = 'assets/images/circle-icon.png';
  static const String redCircleIconImagePath = 'assets/images/red-circle-icon.png';
  static const String timerIconImagePath = 'assets/images/timer-icon.png';
  static const String arrowIconImagePath = 'assets/images/arrow-icon.png';

  int? _selectedItemIndex;
  late List<bool> _isImageVisibleList;

  @override
  void initState() {
    super.initState();

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
    _isImageVisibleList =
        List<bool>.filled(items.length, false); // 모든 아이템에 대해 false로 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "PathPal"),
      body: Column(
        children: [
          Container(
            height: 460,
            color: background,
            child: MyGoogleMap(
              center: _center,
              markers: _markers,
              onMapCreated: (controller) {
                mapController = controller;
              },
              currentLocationFunction: _currentLocation,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 70,
                        color: _selectedItemIndex == index ? background : null,
                        child: _buildListItem(context, index),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path, {double width = 5}) {
    return Image(image: AssetImage(path), width: width);
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      height: 70,
      color: _selectedItemIndex == index ? background : null,
      child: ListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Column(
                children: [
                  _buildImage(basicProfileImagePath),
                  Text(
                    '전창하',
                    style: appTextTheme().labelSmall,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        _buildImage(circleIconImagePath),
                        SizedBox(
                          width: 15,
                        ),
                        Text('출발지 : 공릉역',
                            style: appTextTheme().labelSmall)
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        _buildImage(redCircleIconImagePath),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '도착지 : 하계역',
                          style: appTextTheme().labelSmall,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Row(
                      children: [
                        _buildImage(timerIconImagePath, width: 7),
                        SizedBox(
                          width: 13,
                        ),
                        Text('출발시간 : 오늘(월) 17:35',
                            style: appTextTheme().labelSmall)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(50, 15, 0, 0),
                child: Column(
                  children: [
                    if (_isImageVisibleList[
                    index]) // 해당 아이템의 이미지 표시 상태가 참이면 이미지 표시
                      GestureDetector(
                        onTap: () {
                          // 여기에 이미지를 눌렀을 때 실행할 로직을 작성합니다.
                          print(
                              'Image tapped!'); // 예시로 콘솔에 메시지를 출력하였습니다.
                        },
                        child: _buildImage(arrowIconImagePath, width: 20),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            if (_selectedItemIndex != null) {
              // 이전에 선택된 아이템이 있으면
              _isImageVisibleList[_selectedItemIndex!] =
              false; // 이전에 선택된 아이템의 이미지를 숨김
            }
            _selectedItemIndex = index;
            _isImageVisibleList[index] = true;
          });
          _onMapCreated(mapController, items[index]['출발지']!,
              items[index]['도착지']!);
        },
      ),
    );
  }

  void _currentLocation() async {
    final currentLocation = await mapService.getCurrentLocation();

    setState(() {
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
