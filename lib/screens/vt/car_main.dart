import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/screens/vt/car_detail.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/widgets/appBar.dart';

import '../../colors.dart';
import '../../utils/app_images.dart';
import '../../widgets/build_image.dart';
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('cars').snapshots(),
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
                            color: _selectedItemIndex == index ? background : null,
                            child: _buildListItem(context, index, car),
                          );
                        },
                      );
                    }
                  ),
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
      stream: FirebaseFirestore.instance.collection('disabledPerson').doc(car['dp_uid']).snapshots(),
      builder: (context, snapshot) {
        
        
        if (!snapshot.hasData) {
          // 데이터가 로드되지 않았을 때의 처리를 해줍니다.
          return CircularProgressIndicator();
        }
        var doc = snapshot.data!;
        print(snapshot.data?.get('profileUrl'));
        GeoPoint location = car['departure_address'];
        DateTime date = car['departure_time'].toDate();
        String dateString = date.toString();
        Future<String?> address = getAddressFromLatLng(location.latitude, location.longitude);

        
        return Container(
          height: 70,
          color: _selectedItemIndex == index ? background : null,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Column(
                    children: [
                      BuildImage.buildProfileImage(doc.get('profileUrl'), width: 30),
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
                      Container(
                        child: Row(
                          children: [
                            BuildImage.buildImage(AppImages.circleIconImagePath),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(child: Text('출발지 : ${address}', style: appTextTheme().labelSmall))
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            BuildImage.buildImage(AppImages.redCircleIconImagePath),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(child: Text(
                              '도착지 : 공릉역',
                              style: appTextTheme().labelSmall,
                            ))
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            BuildImage.buildImage(AppImages.timerIconImagePath, width: 7),
                            SizedBox(
                              width: 13,
                            ),
                            Flexible(child: Text('출발시간 : ${dateString}',
                                style: appTextTheme().labelSmall))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isImageVisibleList[
                index]) // 해당 아이템의 이미지 표시 상태가 참이면 이미지 표시
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,15),
                    child: GestureDetector(
                      onTap: () {
                        // 여기에 이미지를 눌렀을 때 실행할 로직을 작성합니다.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CarDetail(
                                  markers: _markers,
                                  center: _center,
                                  onMapCreated: (controller) {
                                    mapController = controller;
                                  },
                                  currentLocationFunction: _currentLocation,
                                )));
                      },
                      child: BuildImage.buildImage(AppImages.arrowIconImagePath, width: 20),
                    ),
                  ),
              ],
            ),
            onTap: () {
              // ... 기존 코드 ...
            },
          ),

        );
      }
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

  Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        return pos.street;
      }
      return "No address available";
    } catch (e) {
      return "Error : ${e.toString()}";
    }
  }
}
