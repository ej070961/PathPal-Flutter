import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/widgets/appBar.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:pathpal/widgets/next_button.dart';

import '../../service/map_service.dart';
import '../../widgets/dp_info.dart';

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
  bool _showCustomWidget = false;

  @override
  Widget build(BuildContext context) {
    if (_showCustomWidget) {
      return Scaffold(
        body: Stack(
          //Stack 위젯 추가
          children: [
            // Google Map
            Positioned.fill(
              child: MyGoogleMap(
                center: _center,
                currentLocationFunction: _currentLocation,
                markers: _markers,
                onMapCreated: (controller) {
                  mapController = controller;
                },
                onTap: () {
                  setState(() {
                    _showCustomWidget = false;
                    print("df");
                  });
                },
              ),
            ),
            // DpInfo (상단에 배치)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200,
              child: DpInfo(backgroundColor: background,),
            ),
            // NextButton (하단에 배치)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NextButton(
                title: "확인",
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: MyAppBar(
          title: "PathPal",
        ),
        body: MyGoogleMap(
          center: _center,
          currentLocationFunction: _currentLocation,
          markers: _markers,
          onMapCreated: (controller) {
            mapController = controller;
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _currentLocation(); // 현재 위치 마커를 불러옵니다.

    fetchWalksData();
  }

  void _onMarkerTapped() {
    setState(() {
      _showCustomWidget = true;
    });
  }

  void _currentLocation() async {
    final currentLocation = await mapService.getCurrentLocation();

    setState(() {
      _center = currentLocation;
      _markers.add(
        Marker(
            markerId: MarkerId('myLocation'),
            position: _center!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            alpha: 0.8,
            onTap: () {
              _onMarkerTapped();
            }),
      );
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _center!,
        zoom: 15.0,
      ),
    ));
  }

  Future<void> fetchWalksData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('walks').get();

    snapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        // data가 null인지 확인
        GeoPoint geoPoint = data['departure_latlng'];
        LatLng location = LatLng(geoPoint.latitude, geoPoint.longitude);
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: location,
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }
    });
  }
}
