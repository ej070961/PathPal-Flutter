import 'package:cloud_firestore/cloud_firestore.dart';

class Volunteer {
  late final String? uid;
  late final String? profileUrl;
  late final String? email;
  late final String? name;
  late final String? phoneNumber;
  late final String? carNumber;

  Volunteer(
      {required this.uid,
      required this.profileUrl,
      required this.email,
      required this.name,
      required this.phoneNumber,
      this.carNumber});

  Volunteer.fromSnapshot(DocumentSnapshot snapshot) {
    uid = snapshot['uid'];
    profileUrl = snapshot['profileUrl'];
    email = snapshot['email'];
    name = snapshot['name'];
    phoneNumber = snapshot['phoneNumber'];
    // 만약 carName 필드도 있으면 아래와 같이 추가
    carNumber = snapshot['carNumber'];
  }
}
