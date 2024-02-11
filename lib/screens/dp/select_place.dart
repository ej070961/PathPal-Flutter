import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/place.dart';
import 'package:pathpal/models/walk_state.dart';
import 'package:pathpal/widgets/departure_time.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/models/car_state.dart';
class SelectPlace extends StatefulWidget {
  final Function(String, LatLng)? updateDeparture;
  final Function(String, LatLng)? updateDestination;

  final Place item;
  final String label;
  final String category;

  const SelectPlace(
      {this.updateDeparture,
      this.updateDestination,
      required this.item,
      required this.label,
      required this.category,
      Key? key})
      : super(key: key);

  @override
  State<SelectPlace> createState() => _SelectPlaceState();
}

class _SelectPlaceState extends State<SelectPlace> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  LatLng? _center;

  

  @override
  void initState() {
    super.initState();

    setState(() {
      _center = LatLng(widget.item.latitude, widget.item.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          position: _center!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          alpha: 0.8,
        ),
      );
    });
  }

  //주소 업데이트 함수
  void _updateAddress() {
    String address = widget.item.displayName;
    LatLng latLng = LatLng(widget.item.latitude, widget.item.longitude);

    if (widget.label == '출발지') {
      // widget.updateDeparture?.call(address, latLng);
      if(widget.category == 'car'){
        CarServiceState().departureLatLng = latLng;
        CarServiceState().departureAddress = address;
        Navigator.pop(context);
      }else{
        WalkServiceState().departureLatLng = latLng;
        WalkServiceState().departureAddress = address;
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(
            context, '/WalkPage');
      }

    } else if (widget.label == '목적지') {
      CarServiceState().destinationLatLng = latLng;
      CarServiceState().destinationAddress = address;
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(
          context, '/CarPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          '차량서비스',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [ 
            Expanded(
              child: MyGoogleMap(
                center: _center,
                markers: _markers,
                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.35,
              child: Column(
                children: [
                  DepartureTimeWidget(departureTime: widget.category=='car'? CarServiceState().departureTime!: WalkServiceState().departureTime! ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
                        crossAxisAlignment: CrossAxisAlignment.center, // 가로 방향 중앙 정렬
                        children: [
                          Text(widget.item.formattedAddress),
                          Text(widget.item.displayName)
                        ]
                        )
                    ),
                  NextButton(
                    title: '${widget.label}로 설정',
                    onPressed: () => {_updateAddress()})
                ]),
              ),
            ]);
        }
    ));
  }
}
