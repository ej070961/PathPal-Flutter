import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "마이페이지",
          style: appTextTheme().titleMedium,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
