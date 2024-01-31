import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/dp/car/car_page.dart';
import 'package:pathpal/screens/dp/walk/walk_page.dart';

import '../../widgets/appBar.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State <HomePage> createState() =>  HomePageState();
}

class  HomePageState extends State <HomePage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: MyAppBar(
          title: 'PathPal',
        ),
        body: Center(
          child: Column(
          children: [
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarPage()),
                  );

              },
              child: Container(
                width: 284,
                height: 97,
                color: Colors.white,
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18, 26, 18, 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '차량서비스',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                color: gray400,
                                
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "바로 호출/예약 가능한 차량 픽업서비스",
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/images/car-image.png',
                        height: 47,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalkPage()),
                  );

              },
              child: Container(
                width: 284,
                height: 97,
                color: Colors.white,
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18, 26, 18, 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '도보서비스',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                color: gray400,
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "바로 호출/예약 가능한 도보 픽업서비스",
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                      Image.asset(
                        'assets/images/walk-image.png',
                      )
                    ],
                  ),
                ),
              )
           
            ),
            
            
          ],
          )
        )
      
      );
  }
}