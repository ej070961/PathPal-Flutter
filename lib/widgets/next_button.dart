import 'package:flutter/material.dart';

import '../colors.dart';

class NextButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;

  NextButton({
    required this.title,
    required this.onPressed, // 필수 파라미터로 지정
  }) : super();

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 너비를 화면 너비로 설정
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0, // 그림자 없애기
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // 테두리 둥글게 만드는 효과 없애기
          ),
        ),
      ),
    );
  }
}
