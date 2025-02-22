import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/disabledPerson.dart';
import 'package:pathpal/screens/dp/login.dart';
import 'package:pathpal/service/firestore/user_service.dart';
import 'package:pathpal/widgets/custom_dropdown.dart';
import 'package:pathpal/widgets/navbar.dart';
import 'package:pathpal/widgets/next_button.dart';


class DpSignUp2 extends StatefulWidget {
  final UserCredential? userCredential;
  String? name;
  String? phoneNumber;

  DpSignUp2({super.key, this.userCredential, this.name, this.phoneNumber});

  @override
  State<DpSignUp2> createState() =>
      _DpSignUp2State(userCredential, name, phoneNumber);
}

class _DpSignUp2State extends State<DpSignUp2> {
  final firebaseService = UserService();

  bool _isButtonEnabled = true;

  final UserCredential? userCredential;
  String? name;
  String? phoneNumber;
  String? disabilityType;
  String? wcUse;

  _DpSignUp2State(this.userCredential, this.name, this.phoneNumber);

  @override
  void initState() {
    super.initState();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = disabilityType != null &&
          wcUse != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회원가입',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '필요한 서비스를 받을 수 있도록 기본 정보를 입력해주세요.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '장애정보',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // 드롭다운 버튼.
                      CustomDropDown(
                        onValueChanged: (value){
                          setState(() {
                            disabilityType = value;
                          });
                          _validateFields();
                        }
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '휠체어 사용여부',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                            Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    wcUse = "Yes";
                                  });
                                   _validateFields();
                                },
                                style: OutlinedButton.styleFrom(
                                  fixedSize: Size(MediaQuery.of(context).size.width/2, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                  ),
                                  side: BorderSide(
                                    color: wcUse == "Yes"
                                        ? mainAccentColor
                                        : gray200, // 원하는 색상 값 설정
                                  ),
                                ),
                                child: Text(
                                  "예",
                                  style: TextStyle(
                                    color:
                                        wcUse == "Yes" ? mainAccentColor : gray200,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    wcUse = "No";
                                  });
                                  _validateFields();
                                },
                                style: OutlinedButton.styleFrom(
                                  fixedSize: Size(
                                    MediaQuery.of(context).size.width / 2, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  side: BorderSide(
                                    color: wcUse == "No" ? mainAccentColor : gray200, // 원하는 색상 값 설정
                                  ),
                                ),
                                child: Text(
                                  "아니오",
                                  style: TextStyle(
                                    color:
                                        wcUse == "No" ? mainAccentColor : gray200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NextButton(
          title: "가입완료",
          onPressed: _isButtonEnabled ? _goToNextPage : null
          )
      );
  }

  void _goToNextPage() {
    if (userCredential != null && userCredential?.user != null) {
      DisabledPerson dp = DisabledPerson(
          uid: userCredential?.user?.uid,
          profileUrl: userCredential?.user?.photoURL,
          email: userCredential?.user?.email,
          name: name,
          phoneNumber: phoneNumber,
          disabilityType: disabilityType,
          wcUse: wcUse);
      firebaseService.saveDisabledPerson(dp)
      .then((isSuccess) {
        if (isSuccess) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DpNavBar()),
          );
        } else {
          // 회원 정보 저장 실패 시 로그인 창으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DpLogin()),
          );
        }
      });
    } else {
      print("Null 발생");
    }

    
  }
}
