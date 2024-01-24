import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathpal/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.anton(
          fontSize: 24, 
          fontWeight: FontWeight.w400, 
          color: mainAccentColor
          )
        )
      );
  }
   @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}