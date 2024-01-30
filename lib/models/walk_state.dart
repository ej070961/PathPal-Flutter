import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkServiceState {
  static final WalkServiceState _singleton = WalkServiceState._internal();

  factory WalkServiceState() {
    return _singleton;
  }

  WalkServiceState._internal();

  String? departureAddress;
  LatLng? departureLatLng;
  DateTime? departureTime;
}
