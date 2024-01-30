import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pathpal/screens/dp/Signup/signup_1.dart';
import 'package:pathpal/screens/vt/login.dart';
import 'package:pathpal/widgets/navbar.dart';
import '../../service/auth_service.dart';
import 'package:pathpal/colors.dart';
import '../../service/firestore/user_service.dart';

class DpLogin extends StatefulWidget {
  const DpLogin({super.key});

  @override
  State<DpLogin> createState() => DpLoginState();
}

class DpLoginState extends State<DpLogin> {
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    init();
  }

  final authService = AuthService();

  // 초기화 메서드
  Future<void> init() async {
    // 초기화가 완료되면 스플래시 화면을 닫음
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Column(
                    children: [
                      Text(
                        '장애인 전용 교통지원 서비스',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'PathPal',
                        style: TextStyle(
                            fontSize: 48,
                            fontFamily: "login",
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 270,
                    height: 270,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 279,
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0.0,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              )),
                          icon: Image.asset(
                            'assets/images/google-icon.png',
                            height: 20,
                          ),
                          onPressed: () async {
                            try {
                              final userCredential = await authService.signInWithGoogle();
                              print('userCredential : $userCredential');

                              if (userCredential != null && userCredential.user?.uid != null) {
                                // 사용자가 새로운 사용자인 경우 회원가입 화면으로 이동
                                bool response = await userService.checkDpUser(userCredential.user!.uid);
                                print(response);
                                if ( response == false) {
                                  // Dp 객체 생성 후 회원가입 화면으로 이동합니다.
                                  if(context.mounted){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DpSignup(
                                              userCredential: userCredential)),
                                    );
                                  }
                                  
                                } else {
                                  // 기존 사용자인 경우 홈 화면으로 이동
                                  print("기존 사용자: 홈으로 이동");
                                  if(context.mounted){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context)=> DpNavBar())
                                    );
                                  }
                                }
                              }
                            } catch (e) {
                              // 에러 처리 로직
                              print("Google Login 실패: $e");
                              Fluttertoast.showToast(
                                msg: e.toString(),
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          },
                          label: Text(
                            '구글 계정으로 시작하기',
                            style: TextStyle(color: gray600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        '봉사자 이신가요?',
                        style: TextStyle(fontSize: 14, color: gray600),
                      ),
                      GestureDetector(
                          child: Text(
                            'Go to PathPal for Volunteers',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w100),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VtLogin()));
                          })
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
