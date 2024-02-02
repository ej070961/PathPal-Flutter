import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/widgets/cancel_button.dart';
import 'package:pathpal/widgets/custom_dialog.dart';
import 'package:pathpal/widgets/next_button.dart';
import 'package:pathpal/widgets/progress_app_bar.dart';
import 'package:pathpal/widgets/review_form.dart';
import 'package:pathpal/widgets/stepper.dart';
import 'package:pathpal/widgets/vt_info.dart';

class CarProgress extends StatefulWidget {
  final docId;
  const CarProgress({super.key, this.docId});

  @override
  State<CarProgress> createState() => _CarProgressState();
}

class _CarProgressState extends State<CarProgress> {

  int _setCurrentStep(status){
     switch (status) {
      case 'waiting':
        return 0;
      case 'going':
        return 1;
      case 'boarding':
        return 2;
      default:
        return -1;
    }
  }

  void _cancelRequest(context) async{
    print("Cancel Request button pressed");
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return RectangleDialog(
          title: '요청 취소',
          message: '정말로 차량서비스 요청을 취소하시겠습니까?',
          okLabel: '확인',
          cancelLabel: '취소',
          okPressed: () {
            FirebaseFirestore.instance
                .collection('cars')
                .doc(widget.docId)
                .delete()
                .then((_) {
                  Navigator.of(context).popUntil((route) => route.isFirst); //앱의 첫 페이지로 돌아감  
            });
          },
        );
      }
    );
  }
   @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: 
            ProgressAppBar(),
        body: Builder(
          builder: (BuildContext context) {
            final double appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
            final double screenHeight = MediaQuery.of(context).size.height;
            final double stepperHeight = (screenHeight - appBarHeight) * 0.2;
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('cars').doc(widget.docId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(); // 데이터가 로딩 중일 때 보여줄 위젯
                }
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>; // 받아온 문서의 데이터

                DateTime? vtTime;
                if(data['status'] != 'waiting'){
                  vtTime = data['volunteer_time'].toDate();
                }
                return Column(
                  children: [
                    SizedBox(
                      height: stepperHeight, 
                      child: CustomStepper(
                        steps: ['접수완료 및 수락 대기 ', '수락완료', '탑승완료'],
                        currentStep: _setCurrentStep(data['status']),
                      )
                    ),
                    Expanded(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        //신청 취소 or 신청 확정 버튼 
                        data['status'] != 'boarding'
                          ? CancelButton(
                            title: "신청 취소하기",
                            onPressed: () {
                              print('click');
                              _cancelRequest(context);
                            })
                            :Container(
                              width: double.infinity,
                              height: 45,
                              color: Colors.white,
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    color: gray400,
                                    Icons.check_circle,
                                    size: 18 ),
                                  SizedBox(width: 5,),
                                  Text(
                                    "신청 확정"
                                  )
                                ]),
                            ),
                        SizedBox(
                          height: 30,
                        ),
                        // status가 going일 때 봉사자 정보 표시 
                        data['status'] == 'going'
                        ? 
                        VtInfo(vtUid: data['vt_uid'], vtTime: vtTime!)
                        : Container(),

                        //status가 boarding일 때 리뷰작성 폼 표시
                        data['status'] == 'boarding'
                        ?
                        ReviewForm(dpUid: data['dp_uid'], vtUid: data['vt_uid'], reqId: widget.docId, category: 'car')
                        : Container()
                
                  ],
                )),

              ],
            );
          },
        );
      })
      );
  }
}