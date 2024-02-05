import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/utils/format_time.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VtInfo extends StatelessWidget {
  final String vtUid;
  final DateTime vtTime;
  final String category;
  const VtInfo(
      {Key? key,
      required this.vtUid,
      required this.vtTime,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: gray200,
                width: 0.5,
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(30.0, 8.0, 0, 0),
          child: Text(
            '${FormatTime.formatTime(vtTime)} 도착예정',
            style: appTextTheme().bodyLarge,
          ),
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('volunteers')
                .doc(vtUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // 데이터가 로딩 중일 때 보여줄 위젯
              }
              Map<String, dynamic> vtData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          //프로필 이미지 원형으로 표시하기
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipOval(
                              child: BuildImage.buildProfileImage(
                                  vtData['profileUrl']),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              category == 'car'
                                  ? Text(
                                      vtData['carNumber'],
                                      style: appTextTheme()
                                          .bodyLarge!
                                          .copyWith(color: subAccentColor),
                                    )
                                  : Container(),
                              Text(
                                vtData['name'],
                                style: appTextTheme().bodyMedium,
                              ),
                            ],
                          )
                        ],
                      ),
                      // Icon(Icons.call),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse('tel:${vtData['phoneNumber']}');
                          print('tel:${vtData['phoneNumber']}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Icon(Icons.call),
                      )
                    ],
                  ));
            })
      ],
    );
  }
}
