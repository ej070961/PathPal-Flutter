import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/app_images.dart';
import 'build_image.dart';

class CancelButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;

  CancelButton({
    required this.title,
    required this.onPressed, // 필수 파라미터로 지정
  }) : super();

  @override
  State<CancelButton> createState() => _State();
}

class _State extends State<CancelButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print("취소");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildImage.buildImage(AppImages.cancelIconImagePath,
                width: 13),
            Text(
              "봉사 취소하기",
              style: appTextTheme()
                  ?.bodyMedium
                  ?.copyWith(color: Colors.red), // 텍스트 색상 빨강으로 변경
            ),
          ],
        ),
        style: ButtonStyle(
          overlayColor:
          MaterialStateProperty.all(Colors.transparent),
          // 클릭 시 색상 변경 없애기
          backgroundColor:
          MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(0),
          // 그림자 없애기
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.zero, // 테두리 둥글게 만드는 효과 없애기
            ),
          ),
        ),
      ),
    );
  }
}
