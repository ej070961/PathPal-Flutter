import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarServiceState {
  static final CarServiceState _singleton = CarServiceState._internal();

  factory CarServiceState() {
    return _singleton;
  }

  CarServiceState._internal();

  String? departureAddress;
  LatLng? departureLatLng;
  String? destinationAddress;
  LatLng? destinationLatLng;
  DateTime? departureTime; 

  void resetState() {
    departureAddress = null;
    departureLatLng = null;
    departureTime = null;
    destinationAddress = null;
    destinationLatLng = null;
    // 나머지 필드도 초기화
  }

}
