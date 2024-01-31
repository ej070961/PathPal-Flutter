import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/app_images.dart';
import '../utils/dp_data.dart';
import '../utils/format_time.dart';
import 'build_image.dart';
import 'item_info_list.dart';

class DpInfo extends StatelessWidget {
  final Color backgroundColor;

  DpInfo({this.backgroundColor = Colors.transparent});



  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            width: 50,
            child: BuildImage.buildProfileImage(DpData.profileUrl),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("   ${DpData.name}", style: appTextTheme().labelSmall),
              Text("  |  ", style: appTextTheme().labelSmall),
              Text("${DpData.disabilityType}", style: appTextTheme().labelSmall),
              Text("  |  ", style: appTextTheme().labelSmall),
              Text("${DpData.wcUseText}", style: appTextTheme().labelSmall),
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
                data: DpData.departureAddress.toString(),
              ),
              SizedBox(
                height: 5,
              ),
              ItemInfoList(
                imagePath: AppImages.redCircleIconImagePath,
                label: '도착지',
                data: DpData.destinationAddress.toString(),
              ),
              SizedBox(
                height: 5,
              ),
              ItemInfoList(
                imagePath: AppImages.timerIconImagePath,
                label: '출발시간',
                data: FormatTime.formatTime(DpData.time),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
