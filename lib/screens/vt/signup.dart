import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/vt/login.dart';
import 'package:pathpal/widgets/next_button.dart';

class VtSignUp extends StatefulWidget {
  @override
  State<VtSignUp> createState() => _VtSignUpState();
}

class _VtSignUpState extends State<VtSignUp> {
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
                      Text(
                        '이름',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // enabledBorder 가 들어간다면 border 는 무시됩니다.
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: gray200,
                          )),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '전화번호',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: gray200,
                              )),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
              child: NextButton(title: "다음", onPressed: _isButtonEnabled ? _goToNextPage : null))
        ],
      ),

    );
  }

  void _goToNextPage() {
    // 다음 페이지로 이동하는 로직
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VtLogin()),
    );
  }
}
