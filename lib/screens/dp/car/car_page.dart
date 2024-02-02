import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/car_model.dart';
import 'package:pathpal/screens/dp/car/car_progress.dart';
import 'package:pathpal/screens/dp/car/car_search.dart';
import 'package:pathpal/utils/app_images.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:pathpal/widgets/departure_time.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/models/car_state.dart';
import 'package:pathpal/service/firestore/car_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPage();
}

class _CarPage extends State<CarPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  LatLng? _center;
  String? departureAddress = CarServiceState().departureAddress;
  LatLng? departureLatLng = CarServiceState().departureLatLng;
  String? destinationAddress = CarServiceState().destinationAddress;
  LatLng? destinationLatLng = CarServiceState().destinationLatLng;
  DateTime? departureTime;

  bool areDepartureAndDestinationSet() {
    // 출발지와 목적지가 모두 설정되었는지 확인
    return CarServiceState().departureAddress != null &&
        CarServiceState().destinationAddress != null;
  }

  @override
  void initState() {
    super.initState();
    _center = const LatLng(37.6300, 127.0764);
    CarServiceState().departureAddress ?? _getcurrentLocation();
    CarServiceState().departureTime =
        CarServiceState().departureTime ?? DateTime.now();
  }

  void _getcurrentLocation() async {
    final currentLatLng= await mapService.getCurrentLocation();
     // 역지오코딩을 통해 현재 위치의 주소를 가져옵니다.
    final placemarks = await placemarkFromCoordinates(
        currentLatLng.latitude, currentLatLng.longitude);

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final address ='${placemark.street}';
      CarServiceState().departureAddress = address; // 현재 위치의 주소를 반환
    } else {
      CarServiceState().departureAddress = '현 위치';
    }
    setState(() {
      CarServiceState().departureLatLng = currentLatLng;
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          alpha: 0.8,
        ),
      );
    });
  }

  void _goToSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Container(child: Search()),
        ));
  }

  final firebaseService = CarService();

  void _submitForm() async {
    print("submitForm");
    // Firebase에서 현재 사용자의 uid 가져오기
    final dpUid = FirebaseAuth.instance.currentUser!.uid;
    CarModel car = CarModel(
        departureAddress: departureAddress,
        departureLatLng: departureLatLng,
        departureTime: CarServiceState().departureTime,
        destinationAddress: destinationAddress,
        destinationLatLng: destinationLatLng,
        dpUid: dpUid,
        status: "waiting");

    firebaseService.saveCarServiceData(car)
    .then((docId) {
      if (docId != null) {
        CarServiceState().resetState();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container(child: CarProgress(docId: docId)),
            ));
      } else {
        // 회원 정보 저장 실패 시 로그인 창으로 이동
        print("저장 실패 오류");
      }
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                CarServiceState().resetState();
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(
            '차량서비스',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(children: [
              Expanded(
                child: MyGoogleMap(
                  center: _center,
                  markers: _markers,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  currentLocationFunction: _currentLocation,
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.39,
                child: Column(children: [
                  DepartureTimeWidget(departureTime: CarServiceState().departureTime!),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(children: [
                        GestureDetector(
                          child: Expanded(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset('assets/images/circle-icon.png'),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text("출발지 : "),
                              ),
                              Flexible(
                                  child: Text(
                                    CarServiceState().departureAddress ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  )
                              )
                            ],
                            )
                          ),
                          onTap: () {
                            _goToSearch();
                          },
                        ),
                        SizedBox(height: 5),
                        Divider(color: gray200),
                        GestureDetector(
                          child: Expanded(
                            child: Row(
                            children: [
                              Image.asset('assets/images/red-circle-icon.png'),
                              SizedBox(width: 10),
                              Text("목적지 : "),
                              Flexible(
                                  child: Text(
                                    CarServiceState().destinationAddress?? ' ',
                                     overflow: TextOverflow.ellipsis,
                                ))
                            ],
                          ),
                          ),
                          onTap: () {
                            _goToSearch();
                          },
                        ),
                        SizedBox(height: 5),
                        Divider(color: gray200),
                      ]),
                    ),
                  ),
                  NextButton(
                    title: "신청하기",
                    onPressed: areDepartureAndDestinationSet()
                        ? () => _submitForm()
                        : null,
                  )
                ]),
              ),
            ]);
          },
        ));
        
}
}
