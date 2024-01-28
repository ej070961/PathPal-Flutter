import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/dp/search.dart';
import 'package:pathpal/utils/app_images.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:pathpal/widgets/departure_time.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/widgets/next_button.dart';

class CarService extends StatefulWidget {
  const CarService({super.key});

  @override
  State<CarService> createState() => _CarServiceState();
}

class _CarServiceState extends State<CarService> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final MapService mapService = MapService();
  LatLng? _center;
  late DateTime _departureTime;  //출발시간
  // late LatLng? _departureAddress;
  // late LatLng? _destinationAddress;

  String? _departureAddress;
  String? _destinationAddress;

  @override
  void initState() {
    super.initState();
    _center = const LatLng(37.6300, 127.0764);
    _departureTime = DateTime.now();
    _departureAddress = '';
    _destinationAddress = '';
  }

  void _currentLocation() async {
    final currentLocation = await mapService.getCurrentLocation();

    setState(() {
      _center = currentLocation;
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

  void _goToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Search()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double boxHeight =  MediaQuery.of(context).size.height * 0.3;
    double mapHeight = screenHeight - appBarHeight - boxHeight -24;
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
            // color: background,
            child: MyGoogleMap(
              center: _center,
              markers: _markers,
              onMapCreated: (controller) {
                mapController = controller;
              },
              currentLocationFunction: _currentLocation,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                DepartureTimeWidget(departureTime: _departureTime),
                Expanded(
                  child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/circle-icon.png'),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text("출발지 : "),
                            ),
                            Flexible(
                              child: Text('$_departureAddress')
                            )
                          ],
                          ),
                        onTap: (){
                          _goToSearch();
                        },
                      ),
                      SizedBox(height: 5),
                      Divider(color: gray200),
                      GestureDetector(
                        child: Expanded(
                          child: Row(
                            children: [
                              Image.asset('assets/images/red-circle-icon.png'),
                              SizedBox(width: 10), 
                              Text(
                                "목적지 : "),
                              Flexible(child: Text('$_destinationAddress'))
                              ],
                            ),
                        ),
                        onTap: () {
                              _goToSearch();
                            },
                      ),
                      SizedBox(height: 5),
                      Divider(color: gray200),
                  ]),
                  ),
                ),
                NextButton(title: "다음", onPressed: () => print('click'))
            ])

          ),
          
        ])
    );
     
 
  }
}

