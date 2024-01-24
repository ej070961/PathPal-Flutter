import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathpal/screens/dp/Signup/signup_2.dart';
import 'package:pathpal/screens/dp/login.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pathpal/widgets/next_button.dart';
import '../../../widgets/custom_text_field.dart';

class DpSignup extends StatefulWidget {
  final UserCredential? userCredential;

  DpSignup({super.key, this.userCredential});

  @override
  _DpSignupState createState() => _DpSignupState();
}

class _DpSignupState extends State<DpSignup> {

    final _nameController = TextEditingController();
    final _phoneNumberController = TextEditingController();

    bool _isButtonEnabled = false;

    @override
    void initState() {
      super.initState();
      _nameController.addListener(_validateFields);
      _phoneNumberController.addListener(_validateFields);
    }


    @override
    void dispose() {
      _nameController.dispose();
      _phoneNumberController.dispose();
      super.dispose();
    }

    void _validateFields() {
      setState(() {
        _isButtonEnabled = _nameController.text.isNotEmpty &&
            _phoneNumberController.text.isNotEmpty;
      });
    }

  @override
  Widget build(BuildContext context) {
    final userCredential = widget.userCredential;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print("뒤로가기버튼");
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
                    value: 0.5,
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
                        controller: _nameController,
                        label: '이름',
                      ),
                      CustomTextField(
                        controller: _phoneNumberController,
                        label: '전화번호',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        
        ]
      ),
      bottomNavigationBar: NextButton(
          title: "다음",
          onPressed: _isButtonEnabled ? _goToNextPage : null
          )
      );
    
   

  }
  void _goToNextPage() {
    // 다음 페이지로 이동하는 로직
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DpSignUp2(
                userCredential: widget.userCredential,
                name: _nameController.text,
                phoneNumber: _phoneNumberController.text,
              )
      ),
    );
  }
}