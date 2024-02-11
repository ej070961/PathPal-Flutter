import 'package:cloud_firestore/cloud_firestore.dart';

class DpData {
  static String? name;
  static String? profileUrl;
  static String? disabilityType;
  static bool wcUse = false;
  static String? wcUseText;
  static GeoPoint? location;
  static String? departureAddress;
  static String? destinationAddress;
  static String? content;
  static DateTime time = DateTime.now();

  static void setCarData(dynamic dpSnapshot, dynamic carSnapshot) {
    name = dpSnapshot.data?.get('name');
    profileUrl = dpSnapshot.data?.get('profileUrl');
    disabilityType = dpSnapshot.data?.get('disabilityType');
    wcUse = dpSnapshot.data?.get('wcUse') == "Yes";
    wcUseText = wcUse ? "휠체어o" : "휠체어x";
    location = carSnapshot['departure_latlng'];
    departureAddress = carSnapshot['departure_address'];
    destinationAddress = carSnapshot['destination_address'];
    time = carSnapshot['departure_time'].toDate();
  }

  static void setWalkData(dynamic dpSnapshot, dynamic walkSnapshot) {
    resetDestination();
    name = dpSnapshot.data?.get('name');
    profileUrl = dpSnapshot.data?.get('profileUrl');
    disabilityType = dpSnapshot.data?.get('disabilityType');
    wcUse = dpSnapshot.data?.get('wcUse') == "Yes";
    wcUseText = wcUse ? "휠체어o" : "휠체어x";
    location = walkSnapshot['departure_latlng'];
    departureAddress = walkSnapshot['departure_address'];
    time = walkSnapshot['departure_time'].toDate();
    content = walkSnapshot['content'];
  }

  static void resetDestination() {
    destinationAddress = null;
  }

}