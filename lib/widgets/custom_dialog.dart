import 'package:flutter/material.dart';
import 'package:pathpal/theme.dart';

import '../colors.dart';

class RectangleDialog extends StatelessWidget {
  final String title;
  final String message;
  final String okLabel;
  final String cancelLabel;
  final VoidCallback okPressed;

  RectangleDialog({
    required this.title,
    required this.message,
    this.okLabel = '확인',
    this.cancelLabel = '취소',
    required this.okPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(dialogBackgroundColor: Colors.white),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(  // 직사각형 형태
          borderRadius: BorderRadius.circular(0), // 각을 0으로 설정
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: appTextTheme().titleMedium,),
            Divider(color: gray200,)
          ],
        ),
        content: Text(message, style: appTextTheme().bodyMedium,),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom( // 직사각형 버튼
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(cancelLabel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom( // 직사각형 버튼
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(okLabel),
            onPressed: okPressed,
          ),
        ],
      ),
    );
  }
}
