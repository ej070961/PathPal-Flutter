import 'package:flutter/material.dart';

import '../theme.dart';
import 'build_image.dart';

class ItemInfoList extends StatelessWidget {

  final String imagePath;
  final String label;
  final String? data;

  ItemInfoList({
    super.key,
    required this.imagePath,
    required this.label,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      // data가 null인 경우에는 아무것도 반환하지 않습니다.
      return Container();
    }

    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildImage.buildImage(this.imagePath),
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5, // 화면 너비의 절반을 차지하도록 설정
              child: Text(
                '$label : $data',
                style: appTextTheme().labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
