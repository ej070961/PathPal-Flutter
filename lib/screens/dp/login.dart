import 'package:flutter/material.dart';

class DpLogin extends StatefulWidget {
  const DpLogin({super.key});

  @override
  State <DpLogin> createState() =>  DpLoginState();
}

class  DpLoginState extends State <DpLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login 화면 입니다.')
      )
    );
  }
}