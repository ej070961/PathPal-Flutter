import 'package:flutter/material.dart';

class ReviseInfo extends StatefulWidget {
  const ReviseInfo({super.key});

  @override
  State<ReviseInfo> createState() => _ReviseInfoState();
}

class _ReviseInfoState extends State<ReviseInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('회원정보수정 화면 입니다.')));
  }
}