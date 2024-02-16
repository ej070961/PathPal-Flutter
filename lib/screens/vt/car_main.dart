import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/screens/vt/car_detail.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/widgets/appBar.dart';
import 'package:shimmer/shimmer.dart';

import '../../colors.dart';
import '../../utils/app_images.dart';
import '../../utils/format_time.dart';
import '../../widgets/build_image.dart';
import '../../widgets/google_map.dart';
import '../../widgets/item_info_list.dart';

class CarMain extends StatefulWidget {
  final String vtUid;
  const CarMain({Key? key, required this.vtUid}) : super(key: key);

  @override
  State<CarMain> createState() => _CarMainState();
}

class _CarMainState extends State<CarMain> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  List<Map<String, LatLng>> items = [];
  LatLng? _center;

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
        List<bool>.filled(10, false); // 모든 아이템에 대해 false로 초기화
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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cars')
                          .where('status', isEqualTo: 'waiting')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator(); // 데이터가 로딩 중일 때 보여줄 위젯
                        }

                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot car = snapshot.data!.docs[index];
                            return Container(
                              height: 70,
                              color: _selectedItemIndex == index
                                  ? background
                                  : null,
                              child: _buildListItem(context, index, car),
                            );
                          },
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, DocumentSnapshot car) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('disabledPerson')
            .doc(car['dp_uid'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var doc = snapshot.data!;
          GeoPoint latlng = car['departure_latlng'];
          String departureAddress = car['departure_address'];
          String destinationAddress = car['destination_address'];
          DateTime date = car['departure_time'].toDate() ?? DateTime(2024, 1, 31);
          String dateString = date.toString();
          Future<String?> address =
              getAddressFromLatLng(latlng.latitude, latlng.longitude);

          return Container(
            height: 70,
            color: _selectedItemIndex == index ? background : null,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 30, 0),
                    child: Column(
                      children: [
                        BuildImage.buildProfileImage(doc.get('profileUrl'),
                            width: 30),
                        Text(
                          doc.get('name'),
                          style: appTextTheme().labelSmall,
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      children: [
                        ItemInfoList(
                          imagePath: AppImages.circleIconImagePath,
                          label: '출발지',
                          data: departureAddress,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ItemInfoList(
                          imagePath: AppImages.redCircleIconImagePath,
                          label: '도착지',
                          data: destinationAddress,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ItemInfoList(
                            imagePath: AppImages.timerIconImagePath,
                            label: '출발시간',
                            data: FormatTime.formatTime(
                              date,
                            )),
                      ],
                    ),
                  ),
                  if (_isImageVisibleList[
                      index]) // 해당 아이템의 이미지 표시 상태가 참이면 이미지 표시
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: GestureDetector(
                        onTap: () {
                          // 여기에 이미지를 눌렀을 때 실행할 로직을 작성합니다.

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CarDetail(
                                    vtUid: widget.vtUid ?? '',
                                        markers: _markers,
                                        center: _center,
                                        onMapCreated: (controller) {
                                          mapController = controller;
                                        },
                                        currentLocationFunction:
                                            _currentLocation,
                                        dpSnapshot: snapshot,
                                        carSnapshot: car,
                                      )));
                        },
                        child: BuildImage.buildImage(
                            AppImages.arrowIconImagePath,
                            width: 20),
                      ),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  if (_selectedItemIndex != null) {
                    _isImageVisibleList[_selectedItemIndex!] = false;
                  }
                  _selectedItemIndex = index;
                  _isImageVisibleList[index] = true;
                });
                _onMapCreated(mapController, car);
              },

            ),
          );
        });
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

  Future<void> _onMapCreated(GoogleMapController controller, DocumentSnapshot car) async {
    mapController = controller;

    // Firestore에서 위도와 경도를 가져옵니다.
    GeoPoint departureGeoPoint = car['departure_latlng'];
    GeoPoint destinationGeoPoint = car['destination_latlng'];

    // GeoPoint를 LatLng으로 변환합니다.
    LatLng departure = LatLng(departureGeoPoint.latitude, departureGeoPoint.longitude);
    LatLng destination = LatLng(destinationGeoPoint.latitude, destinationGeoPoint.longitude);

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

    // mapService.moveCamera(controller, departure, destination);
    _updateCameraPosition(departure, destination);
  }

  void _updateCameraPosition(LatLng departure, LatLng destination) async {
    // 남서쪽과 북동쪽을 정의합니다.
    LatLng southwest = LatLng(
        min(departure.latitude, destination.latitude),
        min(departure.longitude, destination.longitude));
    LatLng northeast = LatLng(
        max(departure.latitude, destination.latitude),
        max(departure.longitude, destination.longitude));

    // 두 위치를 포함하는 영역을 계산합니다.
    LatLngBounds bounds = LatLngBounds(southwest: southwest, northeast: northeast);

    // 카메라를 해당 영역에 맞춥니다.
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    mapController.animateCamera(cameraUpdate);
  }



  Future<void> checkDocumentExists(DocumentSnapshot car) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('disablePerson')
        .doc(car['dp_uid'])
        .get();

    if (docSnapshot.exists) {
      print('Document exists on the database');
    } else {
      print('Document does not exist on the database');
    }
  }

  Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        return pos.street;
      }
      return "No address available";
    } catch (e) {
      return "Error : ${e.toString()}";
    }
  }
}
