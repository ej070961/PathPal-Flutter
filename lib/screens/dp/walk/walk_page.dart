import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/car_model.dart';
import 'package:pathpal/models/walk_model.dart';
import 'package:pathpal/screens/dp/car/car_progress.dart';
import 'package:pathpal/screens/dp/car/car_search.dart';
import 'package:pathpal/screens/dp/walk/request_form.dart';
import 'package:pathpal/screens/dp/walk/walk_progress.dart';
import 'package:pathpal/screens/dp/walk/walk_search.dart';
import 'package:pathpal/utils/app_images.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:pathpal/widgets/departure_time.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/models/walk_state.dart';
import 'package:pathpal/service/firestore/walk_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalkPage extends StatefulWidget {
  const WalkPage({super.key});

  @override
  State<WalkPage> createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  LatLng? _center;
  String? departureAddress = WalkServiceState().departureAddress;
  LatLng? departureLatLng = WalkServiceState().departureLatLng;
  DateTime? departureTime;


  bool areDepartureAndContentSet() {
    // 출발지와 목적지가 모두 설정되었는지 확인
    return WalkServiceState().departureAddress != null && WalkServiceState().content != null;
  }

  @override
  void initState() {
    super.initState();
    _center = const LatLng(37.6300, 127.0764);
    WalkServiceState().departureAddress ?? _getcurrentLocation();
    WalkServiceState().departureTime =
        WalkServiceState().departureTime ?? DateTime.now();
  }

  void _getcurrentLocation() async {
    final currentLocation = await mapService.getCurrentLocation();

    setState(() {
      WalkServiceState().departureLatLng = currentLocation;
      WalkServiceState().departureAddress = '현 위치';
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
          builder: (context) => Container(child: WalkSearch()),
        ));
  }

  final firebaseService = CarService();

  void _submitForm() async {
    print("submitForm");
    // Firebase에서 현재 사용자의 uid 가져오기
    final dpUid = FirebaseAuth.instance.currentUser!.uid;
    WalkModel walk = WalkModel(
        departureAddress: departureAddress,
        departureLatLng: departureLatLng,
        departureTime: WalkServiceState().departureTime,
        content: WalkServiceState().content,
        dpUid: dpUid,
        status: "boarding");

    firebaseService.saveWalkServiceData(walk)
    .then((isSuccess) {
      if (isSuccess) {
        WalkServiceState().resetState(); 
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container(child: WalkProgress()),
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
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(
            '도보서비스',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column (
              children: [
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
                  height: MediaQuery.of(context).size.height * 0.39,
                  child: Column(
                    children: [
                      DepartureTimeWidget(departureTime: WalkServiceState().departureTime!),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 53,
                                height: 24,
                                decoration: BoxDecoration(
                                
                                  color: background,
                                  borderRadius: BorderRadius.circular(10)),
                                  child:Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "출발지",
                                      style: TextStyle(color: mainAccentColor),
                                    ),
                                  ),
                              ),
                            SizedBox(height: 10),
                            GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/circle-icon.png'),
                                  SizedBox(width: 10),
                                  Flexible(
                                      child:
                                          Text('${WalkServiceState().departureAddress}'))
                                ],
                              ),
                            onTap: () {
                                _goToSearch();
                              },
                            ),
                            SizedBox(height: 7),
                            Divider(color: gray200),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Container(
                                  width: 90,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      color: background,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "도움 요청사항",
                                      style: TextStyle(color: mainAccentColor),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: gray600,
                                  ),
                                  onTap: () => {
                                     Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Container(child: RequestForm()),
                                      ))
                                  },
                                )
                                
                            ]),      
                      ]),
                  ),
                ),
                NextButton(
                  title: "신청하기",
                  onPressed: areDepartureAndContentSet()
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