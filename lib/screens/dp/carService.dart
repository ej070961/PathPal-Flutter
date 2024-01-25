import 'package:flutter/material.dart';

class CarService extends StatefulWidget {
  const CarService({super.key});

  @override
  State<CarService> createState() => _CarServiceState();
}

class _CarServiceState extends State<CarService> {
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
    body: Center(child: Text('차량서비스 화면 입니다.')));
  }
}