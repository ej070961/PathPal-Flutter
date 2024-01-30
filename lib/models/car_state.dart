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

}
