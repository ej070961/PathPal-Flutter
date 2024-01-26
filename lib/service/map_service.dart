import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapService {
  Future<Set<Marker>> createMarkers(LatLng departure, LatLng destination) async {
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
          snippet: 'Lat: ${location.value.latitude}, Lng: ${location.value.longitude}',
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

  void moveCamera(GoogleMapController controller, LatLng departure, LatLng destination) {
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
}
