import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/dp/requests.dart';
import 'package:pathpal/screens/dp/revise_info.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/widgets/build_image.dart';
import 'package:pathpal/widgets/my_app_bar.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //현재 로그인 중인 사용자 id 가져오기
  final dpUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        body: Center(
            child: Column(
          children: [
            SizedBox(height: 30),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('disabledPerson')
                    .doc(dpUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(); // 데이터가 로딩 중일 때 보여줄 위젯
                  }
                  Map<String, dynamic> dpData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //프로필 이미지 원형으로 표시하기
                      SizedBox(
                        width: 75,
                        height: 75,
                        child: ClipOval(
                          child: BuildImage.buildProfileImage(
                              dpData['profileUrl']),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        dpData['name'],
                        style: appTextTheme().bodyLarge,
                      ),
                      SizedBox(height: 10),
                      Text(
                        dpData['email'],
                        style:
                            appTextTheme().bodyMedium!.copyWith(color: gray400),
                      ),
                    ],
                  );
                }),
            Container(
              padding: EdgeInsets.all(18),
              child: Column(children: [
                Divider(height: 1, color: gray200),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "내 정보 관리",
                          style: appTextTheme().bodyLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () =>  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReviseInfo()
                                      ),
                                    ),
                        )
                      ],
                  )
                ),
                Divider(height: 1, color: gray200),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "탑승 내역",
                          style: appTextTheme().bodyLarge,
                        ),
                        IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Requests()),
                        ),
                        )
                      ],
                    )
                  ),
                Divider(height: 1, color: gray200),
              ]),
            )
          ],
        )));
  }
}
