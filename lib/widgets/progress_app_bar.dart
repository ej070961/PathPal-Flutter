import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';

class ProgressAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ProgressAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: gray200,
            width: 0.5,
          ),
        ),
      ),
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 아이콘을 누르면 현재 창을 닫음
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "진행상태",
          style: appTextTheme().titleMedium,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
