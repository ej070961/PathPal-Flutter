import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/app_images.dart';
import '../utils/format_time.dart';
import 'build_image.dart';
import 'item_info_list.dart';

class DpInfo extends StatelessWidget {
  final String profileUrl;
  final String name;
  final String disabilityType;
  final String wcUseText;
  final GeoPoint? location;
  final DateTime time;

  DpInfo({
    required this.profileUrl,
    required this.name,
    required this.disabilityType,
    required this.wcUseText,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text("${disabilityType}", style: appTextTheme().labelSmall),
              Text("  |  ", style: appTextTheme().labelSmall),
              Text("${wcUseText}", style: appTextTheme().labelSmall),
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
          ),
        ],
      ),
    );
  }
}
