import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathpal/models/walk_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveWalkServiceData(WalkModel wm) async {
    try {
      await firestore.collection('walks').doc().set({
        'departure_address': wm.departureAddress,
        'departure_latlng': GeoPoint(
            wm.departureLatLng!.latitude, wm.departureLatLng!.longitude),
        'departure_time': wm.departureTime,
        'content': wm.content,
        'status': wm.status,
        'dp_uid': wm.dpUid
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
}
