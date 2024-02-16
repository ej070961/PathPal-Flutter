import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathpal/models/disabledPerson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/volunteer.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  void saveVolunteer(Volunteer volunteer) {
    firestore.collection('volunteers').doc(volunteer.uid).set({
      'uid': volunteer.uid,
      'profileUrl': volunteer.profileUrl,
      'email': volunteer.email,
      'name': volunteer.name,
      'phoneNumber': volunteer.phoneNumber,
      'carNumber' : volunteer.carNumber
    });
  }
  Future<Volunteer> getVolunteer(String uid) async {
    try {
      final volunteerSnapshot = await firestore.collection('volunteers').doc(uid).get();
      if (volunteerSnapshot.exists) {
        return Volunteer.fromSnapshot(volunteerSnapshot);
      } else {
        throw Exception("No such volunteer exists");
      }
    } catch (e) {
      // 오류 처리
      print(e.toString());
      throw e;
    }
  }

  Future<bool> saveDisabledPerson(DisabledPerson dp) async {
    try {
      await firestore.collection('disabledPerson').doc(dp.uid).set({
        'uid': dp.uid,
        'profileUrl': dp.profileUrl,
        'email': dp.email,
        'name': dp.name,
        'phoneNumber': dp.phoneNumber,
        'disabilityType': dp.disabilityType,
        'wcUse': dp.wcUse
      });
      print('Successfully saved');
      return true; // 정보 저장 성공
    } catch (error) {
      print(error.toString());
      Fluttertoast.showToast(
        msg: error.toString(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
      return false; // 정보 저장 실패
    }
  }

  Future<bool> checkDpUser(String uid) async {
    try {
      final userSnapshot =
          await firestore.collection('disabledPerson').doc(uid).get();
      return userSnapshot.exists;
    } catch (e) {
      // 오류 처리
      return false;
    }
  }

  Future<bool> checkVtUser(String uid) async {
    try {
      final userSnapshot =
          await firestore.collection('volunteers').doc(uid).get();
      return userSnapshot.exists;
    } catch (e) {
      // 오류 처리
      return false;
    }
  }
}
