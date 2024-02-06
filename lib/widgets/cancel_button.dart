import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils/app_images.dart';
import 'build_image.dart';

class CancelButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;

  CancelButton({super.key, 
    required this.title,
    required this.onPressed, // 필수 파라미터로 지정
  });

  @override
  State<CancelButton> createState() => _State();
}

class _State extends State<CancelButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: widget.onPressed,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BuildImage.buildImage(AppImages.cancelIconImagePath,
                width: 14),
            SizedBox(width: 5),
            Text(
              widget.title,
              style: appTextTheme()
                  .bodyMedium
                  ?.copyWith(color: Colors.red), // 텍스트 색상 빨강으로 변경
            ),
          ],
        ),
      ),
    );
  }
}
