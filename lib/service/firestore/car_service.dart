import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathpal/models/car_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> saveCarServiceData(CarModel cm) async {
    try {
      await firestore.collection('cars')
        .doc()
        .set({
        'departure_address': cm.departureAddress,
        'departure_latlng': GeoPoint(cm.departureLatLng!.latitude, cm.departureLatLng!.longitude),
        'departure_time': cm.departureTime,
        'destination_address': cm.departureAddress,
        'destination_latlng': GeoPoint(cm.destinationLatLng!.latitude, cm.destinationLatLng!.longitude),
        'status': cm.status,
        'dp_uid': cm.dpUid
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