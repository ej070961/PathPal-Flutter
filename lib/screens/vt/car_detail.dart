import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:pathpal/widgets/item_info_list.dart';
import 'package:pathpal/widgets/next_button.dart';


import '../../utils/app_images.dart';
import '../../utils/format_time.dart';
import '../../widgets/build_image.dart';

class CarDetail extends StatelessWidget {
  final LatLng? center;
  final Set<Marker> markers;
  final Function? onMapCreated;
  final Function? currentLocationFunction;
  final AsyncSnapshot<DocumentSnapshot<Object?>> dpSnapshot;
  final DocumentSnapshot carSnapshot;

  CarDetail(
      {Key? key,
      this.center,
      required this.markers,
      this.onMapCreated,
      this.currentLocationFunction,
      required this.dpSnapshot,
      required this.carSnapshot
      });

  @override
  Widget build(BuildContext context) {
    var name = dpSnapshot.data?.get('name');
    var profileUrl = dpSnapshot.data?.get('profileUrl');
    var disabilityType = dpSnapshot.data?.get('disabilityType');
    var wcUse = dpSnapshot.data?.get('wcUse') == "Yes";
    var wcUseText = wcUse ? "휠체어o" : "휠체어x";
    var location = carSnapshot['departure_address'];
    var time = carSnapshot['departure_time'].toDate();

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  child: BuildImage.buildProfileImage(profileUrl),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("   ${name}", style: appTextTheme().labelSmall),
                    Text("  |  ", style: appTextTheme().labelSmall),
                    Text("${disabilityType}", style: appTextTheme().labelSmall,),
                    Text("  |  ", style: appTextTheme().labelSmall),
                    Text("${wcUseText}", style: appTextTheme().labelSmall)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    ItemInfoList(
                      imagePath: AppImages.circleIconImagePath,
                      label: '출발지',
                      data: location.toString(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ItemInfoList(
                      imagePath: AppImages.redCircleIconImagePath,
                      label: '도착지',
                      data: location.toString(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ItemInfoList(
                      imagePath: AppImages.timerIconImagePath,
                      label: '출발시간',
                      data: FormatTime.formatTime(time),
                    ),
                  ],
                )

              ],
            ),
          ),
          Expanded(
            child: MyGoogleMap(
              markers: markers,
              center: center,
              onMapCreated: onMapCreated,
              currentLocationFunction: currentLocationFunction,
            ),
          ),
          NextButton(
              title: "요청 수락하기",
              onPressed: () {
                print("요청 수락하기 버튼");
              })
        ],
      ),
    );
  }
}
