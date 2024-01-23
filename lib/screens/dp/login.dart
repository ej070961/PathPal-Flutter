import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
class DpLogin extends StatefulWidget {
  const DpLogin({super.key});

  @override
  State <DpLogin> createState() =>  DpLoginState();
}

class  DpLoginState extends State <DpLogin> {

    @override
  void initState() {
    super.initState();
    init();
  }

  // 초기화 메서드
  Future<void> init() async {
    // 여기에 필요한 초기화 코드를 추가하세요.
    // 예: 서버에서 설정을 가져오기, 데이터베이스 초기화 등

    // 초기화가 완료되면 스플래시 화면을 닫습니다.
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login 화면 입니다.')
      )
    );
  }
}