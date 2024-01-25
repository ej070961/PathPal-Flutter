import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:pathpal/widgets/next_button.dart';

import '../../utils/app_images.dart';
import '../../widgets/build_image.dart';

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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print("뒤로가기버튼");
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: background,
        toolbarHeight: 30.0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Column(
              children: [
                Container(
                    width: 50,
                    child: BuildImage.buildImage(
                        AppImages.basicProfileImagePath),

                ),
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
          ),
          NextButton(title: "요청 수락하기", onPressed: (){
            print("요청 수락하기 버튼");
          })
        ],
      ),
    );
  }
}
