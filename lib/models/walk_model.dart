import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkModel {
  String? departureAddress;
  LatLng? departureLatLng;
  DateTime? departureTime;
  String? content;
  String? dpUid;
  String? vtUid;
  DateTime? vtTime;
  String? status;

  WalkModel(
      {required this.departureAddress,
      required this.departureLatLng,
      required this.departureTime,
      required this.content,
      required this.dpUid,
      required this.status,
      this.vtTime,
      this.vtUid});
}
