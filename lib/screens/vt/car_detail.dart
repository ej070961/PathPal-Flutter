import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/screens/vt/progress_1.dart';
import 'package:pathpal/theme.dart';
import 'package:pathpal/utils/dp_data.dart';
import 'package:pathpal/widgets/dp_info.dart';
import 'package:pathpal/widgets/google_map.dart';
import 'package:pathpal/widgets/item_info_list.dart';
import 'package:pathpal/widgets/modal_bottom_sheet.dart';
import 'package:pathpal/widgets/next_button.dart';

import '../../utils/app_images.dart';
import '../../utils/format_time.dart';
import '../../widgets/build_image.dart';

class CarDetail extends StatefulWidget {
  final LatLng? center;
  final Set<Marker> markers;
  final Function? onMapCreated;
  final Function? currentLocationFunction;
  final AsyncSnapshot<DocumentSnapshot<Object?>> dpSnapshot;
  final DocumentSnapshot carSnapshot;

  CarDetail({
    Key? key,
    this.center,
    required this.markers,
    this.onMapCreated,
    this.currentLocationFunction,
    required this.dpSnapshot,
    required this.carSnapshot,
  });

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    DpData.setData(widget.dpSnapshot, widget.carSnapshot);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            print("뒤로가기버튼");
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: background,
        toolbarHeight: 30.0,
      ),
      body: Column(
        children: [
          DpInfo(),
          Expanded(
            child: MyGoogleMap(
              markers: widget.markers,
              center: widget.center,
              onMapCreated: widget.onMapCreated,
              currentLocationFunction: widget.currentLocationFunction,
            ),
          ),
          NextButton(
            title: "요청 수락하기",
            onPressed: () {
              ModalBottomSheet.show(
                context,
                timeTitle: '도착시각',
                nextButtonTitle: '다음',
                onPressedToFirestore: (selectedDate) {
                  FirebaseFirestore.instance
                      .collection('cars')
                      .doc(widget.carSnapshot.id)
                      .update({'volunteer_time': selectedDate})
                      .then((_) => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => VtProgress(arriveTime: FormatTime.formatTime(selectedDate) + " 도착 예정",)))
                      .catchError((error) => print('Update failed: $error')));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
