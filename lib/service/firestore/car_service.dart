import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathpal/models/car_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> saveCarServiceData(CarModel cm) async {
   try {
      DocumentReference docRef = await firestore.collection('cars').add({
        'departure_address': cm.departureAddress,
        'departure_latlng': GeoPoint(
            cm.departureLatLng!.latitude, cm.departureLatLng!.longitude),
        'departure_time': cm.departureTime,
        'destination_address': cm.destinationAddress,
        'destination_latlng': GeoPoint(
            cm.destinationLatLng!.latitude, cm.destinationLatLng!.longitude),
        'status': cm.status,
        'dp_uid': cm.dpUid
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
      return null; // 오류 발생 시 null 반환
    }
  }
}