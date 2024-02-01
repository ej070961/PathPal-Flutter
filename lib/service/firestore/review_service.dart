import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pathpal/models/review.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReviewService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

   Future<bool> saveReviewData(ReviewModel rm) async {
    try {
      await firestore.collection('reviews').add({
        'dp_uid': rm.dpUid,
        'vt_uid': rm.vtUid,
        'req_id': rm.reqId,
        'rating': rm.rating,
        'content': rm.content,
        'category': rm.category
      });
      print('Successfully saved');
      return true; // 저장된 문서의 ID를 반환
    } catch (error) {
      print(error.toString());
      Fluttertoast.showToast(
        msg: error.toString(),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
      return false; // 오류 발생 시 null 반환
    }
  }
}