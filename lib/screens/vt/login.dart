import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/dp/login.dart';
import 'package:pathpal/screens/vt/signup_1.dart';
import 'package:pathpal/widgets/navbar_vt.dart';

import '../../service/auth_service.dart';
import '../../service/firestore/user_service.dart';
import 'car_main.dart';

class VtLogin extends StatelessWidget {
  final authService = AuthService();
  final userService = UserService();

  VtLogin({super.key});

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
                        '장애 전용 교통지원 서비스',
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
                      Text(
                        'for Volunteers',
                        style: TextStyle(
                            fontSize: 20,
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
                            final userCredential =
                                await authService.signInWithGoogle();

                            if (userCredential != null) {
                              if (await userService
                                      .checkVtUser(userCredential.user!.uid) ==
                                  true) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VtNavBar(vtUid: userCredential.user!.uid,)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VtSignUp(
                                            userCredential: userCredential)));
                              }
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
                        '장애인사용자 이신가요?',
                        style: TextStyle(fontSize: 14, color: gray600),
                      ),
                      GestureDetector(
                          child: Text(
                            'Go to Original PathPal',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w100),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DpLogin()));
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
