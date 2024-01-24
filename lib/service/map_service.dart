import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  Future<Set<Marker>> createMarkers(GoogleMapController controller, LatLng departure, LatLng destination) async {
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
        icon: location.key == '도착지'
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
            : BitmapDescriptor.defaultMarker,
      );

      markers.add(marker);
    }

    return markers;
  }
}
