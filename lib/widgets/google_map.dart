import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap  extends StatefulWidget{
  final LatLng? center;
  final Set<Marker> markers;
  final Function? onMapCreated;
  final Function? currentLocationFunction;
  final Function? onTap;

  MyGoogleMap({
    Key? key,
    this.center,
    required this.markers,
    this.onMapCreated,
    this.currentLocationFunction,
    this.onTap
  }) : super(key: key);

    @override
  _MyGoogleMapState createState() => _MyGoogleMapState();

}

class _MyGoogleMapState extends State<MyGoogleMap> {
  LatLng? center;

  @override
  void initState() {
    super.initState();
    center = widget.center;
  }

  @override
  void didUpdateWidget(covariant MyGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("update");
    center = widget.center;
    print(center);
  }

  @override
  Widget build(BuildContext context) {

    if (center == null) {
      // center 값이 null인 경우에는 CircularProgressIndicator를 반환    
      return  Center(child: CircularProgressIndicator());
    }


    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          child: GoogleMap(
            onMapCreated: (controller) {
              if (widget.onMapCreated != null) {
                widget.onMapCreated!(controller);
              }
            },
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: center!,
              zoom: 13.0,
            ),
            markers: widget.markers,
          ),
        ),
        Positioned(
          bottom: 45,
          right: 10,
          child: FloatingActionButton(
            foregroundColor: Colors.grey[400],
            backgroundColor: Colors.white,
            onPressed: () {
              if (widget.currentLocationFunction != null) {
                widget.currentLocationFunction!();
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}