import 'package:flutter/material.dart';
import 'package:pathpal/screens/dp/login.dart';
import 'package:pathpal/screens/vt/login.dart';
import 'package:pathpal/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
         options: DefaultFirebaseOptions.currentPlatform, //파이어베이스 연결 코드 
     );
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pathpal',
      theme: ThemeData(
        colorScheme: appColorScheme(), // 컬러 테마 적용
        textTheme: appTextTheme(), //폰트 테마 적용 
        useMaterial3: true,
      ),
      home: VtLogin() //Disabled persion 로그인 화면
    );
  }
}
