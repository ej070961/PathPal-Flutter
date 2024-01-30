import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MapService {
  Future<Set<Marker>> createMarkers(
      LatLng departure, LatLng destination) async {
    final Map<String, LatLng> locations = {
      '출발지': departure,
      '도착지': destination,
    };

    final Set<Marker> markers = {};

    for (final location in locations.entries) {
      final marker = Marker(
        markerId: MarkerId(location.key),
        position: location.value,
        infoWindow: InfoWindow(
          title: location.key,
          snippet:
              'Lat: ${location.value.latitude}, Lng: ${location.value.longitude}',
        ),
        icon: location.key == '출발지'
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)
            : BitmapDescriptor.defaultMarker,
      );

      markers.add(marker);
    }

    return markers;
  }

  Future<LatLng> getCurrentLocation() async {
    final location = Location();
    final currentLocation = await location.getLocation();
    return LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  void moveCamera(
      GoogleMapController controller, LatLng departure, LatLng destination) {
    if (departure != destination) {
      CameraUpdate u2 = CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            (departure.latitude + destination.latitude) / 2,
            (departure.longitude + destination.longitude) / 2,
          ),
          zoom: 13.0,
        ),
      );
      controller.animateCamera(u2).then((void v) {
        controller.animateCamera(u2);
      });
    }
  }

  Future<String> getPlace(String placeText) async {
    String url = "https://places.googleapis.com/v1/places:searchText";
    String key = dotenv.get('GOOGLE_PLACE_API');
    //요청 본문
    //     {
    //   "textQuery": string,
    //   "languageCode": string,
    //   "regionCode": string,
    //   "rankPreference": enum (RankPreference),
    //   "includedType": string,
    //   "openNow": boolean,
    //   "minRating": number,
    //   "maxResultCount": integer,
    //   "priceLevels": [
    //     enum (PriceLevel)
    //   ],
    //   "strictTypeFiltering": boolean,
    //   "locationBias": {
    //     object (LocationBias)
    //   },
    //   "locationRestriction": {
    //     object (LocationRestriction)
    //   }
    // }
    // 요청 본문
    
    Map<String, dynamic> requestBody = {
      "textQuery": placeText,
      "languageCode": "ko",
      "regionCode" : "KR"
    };
    print("requestBody : $requestBody");

    // language=ko 옵션을 추가했다.
    // url += "$placeText&language=ko&key=$key";
    var response = await http.post(Uri.parse(url), 
        headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key" : key,
            "X-Goog-FieldMask" : "places.displayName,places.formattedAddress,places.shortFormattedAddress,places.location,places.addressComponents"
        },
        body: jsonEncode(requestBody));

    var statusCode = response.statusCode;
    // print(" statusCode : $statusCode");
    var responseHeaders = response.headers;
    // print(" header: $responseHeaders");
    var responseBody = response.body;
    // print("responseBody: $responseBody");

    return responseBody;
  }
}
