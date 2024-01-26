import 'package:flutter/material.dart';

import '../theme.dart';
import 'build_image.dart';

class ItemInfoList extends StatelessWidget {

  final String imagePath;
  final String label;
  final String data;

  ItemInfoList({
    super.key,
    required this.imagePath,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
