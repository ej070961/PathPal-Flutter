import 'package:flutter/material.dart';
import 'package:pathpal/screens/vt/progress_2.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/utils/app_images.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:pathpal/widgets/dp_info.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/widgets/progress_app_bar.dart';
import 'package:pathpal/widgets/stepper.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';

class VtProgress extends StatefulWidget {
  String? arriveTime = "";

  VtProgress({this.arriveTime});

  @override
  State<VtProgress> createState() => _VtProgressState();
}

class _VtProgressState extends State<VtProgress> {
  @override
  Widget build(BuildContext context) {
    final stepper = CustomStepper(
      steps: ['가는중', '탑승 완료'],
      currentStep: 0,
    );
    return Scaffold(
      appBar: ProgressAppBar(),
      body: Builder(
        builder: (BuildContext context) {
          final double appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
          final double screenHeight = MediaQuery.of(context).size.height;
          final double stepperHeight = (screenHeight - appBarHeight) * 0.2;

          return Column(
            children: [
              Container(height: stepperHeight, child: stepper),
              Expanded(
                  child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print("취소");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildImage.buildImage(AppImages.cancelIconImagePath,
                              width: 13),
                          Text(
                            "봉사 취소하기",
                            style: appTextTheme()
                                ?.bodyMedium
                                ?.copyWith(color: Colors.red), // 텍스트 색상 빨강으로 변경
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        // 클릭 시 색상 변경 없애기
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(0),
                        // 그림자 없애기
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.zero, // 테두리 둥글게 만드는 효과 없애기
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30.0, 8.0, 0, 0),
                      child: Text(
                        '${widget.arriveTime}',
                        style: appTextTheme().bodyLarge,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: gray200,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  DpInfo(
                    backgroundColor: Colors.white,
                  ),
                ],
              )),
              NextButton(
                title: "탑승 완료",
                onPressed: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VtProgress2()));
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
