import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/place.dart';
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

  const SelectPlace(
      {this.updateDeparture,
      this.updateDestination,
      required this.item,
      required this.label,
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
      CarServiceState().departureLatLng = latLng;
      CarServiceState().departureAddress = address;
      Navigator.pop(context);

    } else if (widget.label == '목적지') {
      CarServiceState().destinationLatLng = latLng;
      CarServiceState().destinationAddress = address;
      // Navigator.pushNamed(context, '/CarService');
      Navigator.pushNamedAndRemoveUntil(
          context, '/CarPage', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxHeight = MediaQuery.of(context).size.height * 0.3;
    double mapHeight = screenHeight - appBarHeight - boxHeight-24;
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
      body: Column(children: [
        SizedBox(
          height: mapHeight,
          child: MyGoogleMap(
            center: _center,
            markers: _markers,
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),
        ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            DepartureTimeWidget(),
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
      ]),
    );
  }
}
