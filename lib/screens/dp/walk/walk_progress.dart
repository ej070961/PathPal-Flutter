import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WalkProgress extends StatefulWidget {
  const WalkProgress({super.key});

  @override
  State<WalkProgress> createState() => _WalkProgressState();
}

class _WalkProgressState extends State<WalkProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('진행상태 화면 입니다.')));
  }
}
