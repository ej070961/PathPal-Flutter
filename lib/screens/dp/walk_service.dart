import 'package:flutter/material.dart';

class WalkService extends StatefulWidget {
  const WalkService({super.key});

  @override
  State<WalkService> createState() => _WalkServiceState();
}

class _WalkServiceState extends State<WalkService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
      body: Center(child: Text('도보서비스 화면 입니다.')));
  }
}