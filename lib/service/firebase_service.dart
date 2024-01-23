import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/volunteer.dart';

class FireBaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void saveVolunteer(Volunteer volunteer) {
    firestore.collection('volunteers').doc(volunteer.uid).set({
      'uid' : volunteer.uid,
      'profileUrl': volunteer.profileUrl,
      'email': volunteer.email,
      'name': volunteer.name,
      'phoneNumber': volunteer.phoneNumber,
    });
  }
}