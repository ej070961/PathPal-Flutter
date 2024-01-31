import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CarProgress extends StatefulWidget {
  const CarProgress({super.key});

  @override
  State<CarProgress> createState() => _CarProgressState();
}

class _CarProgressState extends State<CarProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('진행상태 화면 입니다.')));
  }
}