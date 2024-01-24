  import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/dp/chatBot.dart';
import 'package:pathpal/screens/dp/home.dart';
import 'package:pathpal/screens/dp/my.dart';
import 'package:pathpal/widgets/appBar.dart';

class DpNavBar extends StatefulWidget {
  const DpNavBar({super.key});

  @override
  State<DpNavBar> createState() => _DpNavBarState();
}

class _DpNavBarState extends State<DpNavBar> {

  int selectedIndex = 0;
  
  void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'PathPal',
        ),

      body: Center(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            HomePage(),
            ChatBotPage(),
            MyPage()
          ],
          ) ,
        ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home
              ), 
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.contact_support
              ), 
            label: "챗봇",
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