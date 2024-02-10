
import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
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
              Text("${DpData.disabilityType}",
                  style: appTextTheme().labelSmall),
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
                data: DpData.destinationAddress != null
                    ? DpData.destinationAddress.toString()
                    : null,
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
  Widget buildContent(BuildContext context) {
    return Column(
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
            Text("${DpData.disabilityType}",
                style: appTextTheme().labelSmall),
            Text("  |  ", style: appTextTheme().labelSmall),
            Text("${DpData.wcUseText}", style: appTextTheme().labelSmall),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        buildItemInfoList(),
      ],
    );
  }

  Widget buildItemInfoList() {
    return Column(
      children: [
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
              data: DpData.destinationAddress != null
                  ? DpData.destinationAddress.toString()
                  : null,
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
    );
  }

}

class DpInfoWithComment extends DpInfo {
  DpInfoWithComment({required Color backgroundColor}) : super(backgroundColor: backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      height: 300, // 높이 재조정
      child: buildContent(context),
    );
  }

  @override
  Widget buildItemInfoList() {
    return Column(
      children: [
        super.buildItemInfoList(),
        SizedBox(
          height: 10,
        ),
        CommentBox(),  // 코멘트 박스 추가
      ],
    );
  }
}

class CommentBox extends StatelessWidget {
  // 코멘트 박스 위젯
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // 원하는 가로 길이
      height: 100, // 원하는 세로 길이
      decoration: BoxDecoration(
        color: background, // 원하는 배경 색
        border: Border.all(color: gray200), // 원하는 테두리 색
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${DpData.content}", style: appTextTheme().bodySmall,),
      ), // 원하는 코멘트 표시 방식
    );
  }
}
