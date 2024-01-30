import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarModel {
  String? departureAddress;
  LatLng? departureLatLng;
  String? destinationAddress;
  LatLng? destinationLatLng;
  DateTime? departureTime;
  String? dpUid;
  String? vtUid;
  DateTime? vtTime;
  String? status;

  CarModel({
    required this.departureAddress,
    required this.departureLatLng,
    required this.departureTime,
    required this.destinationAddress,
    required this.destinationLatLng,
    required this.dpUid,
    required this.status,
    this.vtTime,
    this.vtUid
  });
}
