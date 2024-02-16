import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:pathpal/screens/vt/car_main.dart';
import 'package:pathpal/screens/vt/progress_2.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/utils/app_images.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:pathpal/widgets/cancel_button.dart';
import 'package:pathpal/widgets/dp_info.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/widgets/progress_app_bar.dart';
import 'package:pathpal/widgets/stepper.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../widgets/custom_dialog.dart';

class VtProgress extends StatefulWidget {
  String? arriveTime = "";
  String? carId;
  String? walkId;
  bool isWalkService;

  VtProgress({this.arriveTime, this.carId, this.walkId, required this.isWalkService});

  @override
  State<VtProgress> createState() => _VtProgressState();
}

class _VtProgressState extends State<VtProgress> {


  @override
  Widget build(BuildContext context) {
    String buttonTitle = widget.isWalkService ? "도착 완료" : "탑승 완료";

    final stepper = CustomStepper(
      steps: widget.isWalkService ? ['가는중', '도착 완료'] : ['가는중', '탑승 완료'],
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
                      buildButton(
                        title: "봉사 취소하기",
                        dialogTitle: '봉사 취소',
                        dialogMessage: '정말로 봉사를 취소하시겠습니까?',
                        status: 'waiting',
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
              buildButton(
                title: "${buttonTitle}",
                dialogTitle: '${buttonTitle}',
                dialogMessage: '정말로 ${buttonTitle} 버튼을 누르시겠습니까?',
                status: 'boarding',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildButton({required String title, required String dialogTitle, required String dialogMessage, required String status}) {


    return NextButton(
        title: title,
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return RectangleDialog(
                title: dialogTitle,
                message: dialogMessage,
                okLabel: '확인',
                cancelLabel: '취소',
                okPressed: () {
                  String? docId = widget.carId ?? widget.walkId;
                  String collection = widget.carId != null ? 'cars' : 'walks';
                  if (docId != null) {
                    FirebaseFirestore.instance
                        .collection(collection)
                        .doc(docId)
                        .update({'status': status}).then((_) {
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    });
                  }
                },
              );
            },
          );
        }
    );
  }
}

