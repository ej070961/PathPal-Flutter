import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';

class VtLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
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
                Container(
                  child: Image.asset('assets/images/logo.png'),
                  width: 270,
                  height: 270,
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
                        onPressed: () {
                          print("구글 로그인 버튼 클릭");
                        },
                        label: Text(
                          '구글 계정으로 시작하기',
                          style: TextStyle(
                            color: gray600
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '봉사자 이신가요?',
                      style: TextStyle(
                        fontSize: 14,
                        color: gray600
                      ),
                    ),
                    Text(
                      'Go to PathPal for Volunteers',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w100
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
