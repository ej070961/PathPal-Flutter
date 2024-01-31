import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/dp/chatbot.dart';
import 'package:pathpal/screens/dp/home.dart';
import 'package:pathpal/screens/dp/my.dart';
import 'package:pathpal/screens/vt/car_main.dart';
import 'package:pathpal/screens/vt/walk_main.dart';

class VtNavBar extends StatefulWidget {
  final String vtUid;
  const VtNavBar({super.key, required this.vtUid});

  @override
  State<VtNavBar> createState() => _DpNavBarState();
}

class _DpNavBarState extends State<VtNavBar> {

  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            CarMain(vtUid: widget.vtUid),
            WalkMain(),
            MyPage()
          ],
        ) ,
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
                Icons.home
            ),
            label: "차량서비스",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.contact_support
            ),
            label: "도보서비스",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: "마이페이지",
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: mainAccentColor,
        onTap: _onItemTapped,
      ),

    );

  }
}