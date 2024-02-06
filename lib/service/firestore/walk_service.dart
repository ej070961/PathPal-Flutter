import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathpal/models/walk_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WalkService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> saveWalkServiceData(WalkModel wm) async {
    try {
       DocumentReference docRef = await firestore.collection('walks').add({
        'departure_address': wm.departureAddress,
        'departure_latlng': GeoPoint(
            wm.departureLatLng!.latitude, wm.departureLatLng!.longitude),
        'departure_time': wm.departureTime,
        'content': wm.content,
        'status': wm.status,
        'dp_uid': wm.dpUid
      });
      print('Successfully saved');
      return docRef.id; // 저장된 문서의 ID를 반환
    } catch (error) {
      print(error.toString());
      Fluttertoast.showToast(
        msg: error.toString(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
      return null; // 정보 저장 실패
    }
  }
}
