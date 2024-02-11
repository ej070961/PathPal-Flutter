import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/car_model.dart';
import 'package:pathpal/models/walk_model.dart';
import 'package:pathpal/screens/dp/progress.dart';
import 'package:pathpal/screens/dp/car/car_search.dart';
import 'package:pathpal/screens/dp/walk/request_form.dart';
import 'package:pathpal/screens/dp/progress.dart';
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
import 'package:geocoding/geocoding.dart';

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
    if (departureLatLng != null ) {
      setState(() {
        _center = departureLatLng;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('출발지'),
            position: _center!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            alpha: 0.8,
          ),
        );
      });
    }
    WalkServiceState().departureAddress ?? _getcurrentLocation();
    WalkServiceState().departureTime =
        WalkServiceState().departureTime ?? DateTime.now();
  }



  void _getcurrentLocation() async {
    final currentLatLng = await mapService.getCurrentLocation();
    
    setState(() {
      WalkServiceState().departureLatLng = currentLatLng;
      _center =  WalkServiceState().departureLatLng;
    });
    // 역지오코딩을 통해 현재 위치의 주소를 가져옵니다.
    final placemarks = await placemarkFromCoordinates(
        currentLatLng.latitude, currentLatLng.longitude);

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final address = '${placemark.street}';
      WalkServiceState().departureAddress = address; // 현재 위치의 주소를 반환
    } else {
      setState(() {
         WalkServiceState().departureAddress = '현 위치';
      });
    }

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

  final firebaseService = WalkService();

  void _submitForm() async {
    print("submitForm");
    // Firebase에서 현재 사용자의 uid 가져오기
    final dpUid = FirebaseAuth.instance.currentUser!.uid;
    //디버그용
    // const dpUid = "vX4hHeFUvBPJJ03p6vFP9ItEsdy1";
    WalkModel walk = WalkModel(
        departureAddress: WalkServiceState().departureAddress,
        departureLatLng: WalkServiceState().departureLatLng,
        departureTime: WalkServiceState().departureTime,
        content: WalkServiceState().content,
        dpUid: dpUid,
        status: "waiting");

    firebaseService.saveWalkServiceData(walk)
    .then((docId) {
      if (docId != null) {
        WalkServiceState().resetState(); 
        Fluttertoast.showToast(
          msg: '접수가 완료되었어요!',
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Container(child: Progress(docId: docId, category: 'walk',)),
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
                WalkServiceState().resetState();
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
                Flexible(
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
                  height: constraints.maxHeight * 0.32,
                  child: Column(
                    children: [
                      DepartureTimeWidget(departureTime: WalkServiceState().departureTime!),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(15),
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
                            SizedBox(height: 7),
                            GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BuildImage.buildImage(
                                      AppImages.circleIconImagePath),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child:
                                        Text(
                                          WalkServiceState().departureAddress ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      )
                                ],
                              ),
                            onTap: () {
                                _goToSearch();
                              },
                            ),
                            SizedBox(height: 5),
                            Divider(color: gray200),
                            SizedBox(height: 5),
                            //도움요청사항 
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