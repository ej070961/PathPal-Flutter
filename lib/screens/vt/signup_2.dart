import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/volunteer.dart';
import 'package:pathpal/screens/vt/login.dart';
import 'package:pathpal/service/firestore/user_service.dart';
import 'package:pathpal/widgets/next_button.dart';

import '../../widgets/custom_text_field.dart';

class VtSignUp2 extends StatefulWidget {
  final UserCredential? userCredential;
  String? name;
  String? phoneNumber;

  VtSignUp2({super.key, this.userCredential, this.name, this.phoneNumber});

  @override
  State<VtSignUp2> createState() =>
      _VtSignUpState(userCredential, name, phoneNumber);
}

class _VtSignUpState extends State<VtSignUp2> {
  final firebaseService = UserService();
  final _carNumberController = TextEditingController();

  bool _isButtonEnabled = true;
  final UserCredential? userCredential;
  String? name;
  String? phoneNumber;

  _VtSignUpState(this.userCredential, this.name, this.phoneNumber);

  @override
  void initState() {
    super.initState();
    _carNumberController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _carNumberController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _carNumberController.text.isEmpty ||
          _carNumberController.text.length >= 7;
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
                      CustomTextField(
                        controller: _carNumberController,
                        label: '차량번호',
                        hint: "(선택) 차량번호를 입력해주세요(예 : 28어5314)",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: NextButton(
                  title: "가입완료",
                  onPressed: _isButtonEnabled ? _goToNextPage : null))
        ],
      ),
    );
  }

  void _goToNextPage() {
    if (userCredential != null && userCredential?.user != null) {
      Volunteer volunteer = Volunteer(
          uid: userCredential?.user?.uid,
          profileUrl: userCredential?.user?.photoURL,
          email: userCredential?.user?.email,
          name: name,
          phoneNumber: phoneNumber,
          carNumber: _carNumberController.text
      );
      firebaseService.saveVolunteer(volunteer);
    } else {
        print("Null 발생");
    }

    // 다음 페이지로 이동하는 로직
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VtLogin()),
    );
  }
}
