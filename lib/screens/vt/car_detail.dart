import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/widgets/google_map.dart';

class CarDetail extends StatefulWidget {
  final LatLng? center;
  final Set<Marker> markers;
  final Function? onMapCreated;
  final Function? currentLocationFunction;

  CarDetail({
    Key? key,
    this.center,
    required this.markers,
    this.onMapCreated,
    this.currentLocationFunction,
  });

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Column(
              children: [
                
              ],
            ),
          ),
          Expanded(
            child: MyGoogleMap(
              markers: widget.markers,
              center: widget.center,
              onMapCreated: widget.onMapCreated,
              currentLocationFunction: widget.currentLocationFunction,
            ),
          )
        ],
      ),
    );
  }
}
