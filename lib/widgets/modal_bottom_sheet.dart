import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../theme.dart';
import '../utils/format_time.dart';
import 'next_button.dart';

class ModalBottomSheet extends StatefulWidget {
  final String timeTitle;
  final String nextButtonTitle;
  final Function(DateTime)? onPressedToFirestore;
  final Function(DateTime)? onPressed;
  DateTime? initialDateTime;

  ModalBottomSheet({
    super.key, 
    required this.timeTitle,
    required this.nextButtonTitle,
    this.onPressed,
    this.onPressedToFirestore,
    this.initialDateTime
    });

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();

  static show(BuildContext context,{
      required String timeTitle,
      required String nextButtonTitle,
      Function(DateTime)? onPressed,
      Function(DateTime)? onPressedToFirestore,
      DateTime? initialDateTime
  }){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (BuildContext context) {
          return ModalBottomSheet(
            timeTitle: timeTitle,
            nextButtonTitle: nextButtonTitle,
            onPressed: onPressed,
            onPressedToFirestore: onPressedToFirestore,
            initialDateTime: initialDateTime,
          );
    });
  }
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    DateTime initialDateTime = FormatTime.formatCheckMinute(selectedDate);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.timeTitle}     ${DateFormat.yMd('ko_KR').add_Hm().format(selectedDate)}',
                style: appTextTheme().labelMedium,
              ),
            ),
          ),
          Divider(color: gray200),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoDatePicker(
                initialDateTime: initialDateTime,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
                use24hFormat: true,
                minimumDate: DateTime(2024, 1),
                maximumDate: DateTime(2024, 12, 31),
                minuteInterval: 5,
                mode: CupertinoDatePickerMode.dateAndTime,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: NextButton(
              title: widget.nextButtonTitle,
              onPressed: () async {
                if (widget.onPressedToFirestore != null) {
                  print("DB 연결 pressed일 때 ");
                  widget.onPressedToFirestore?.call(selectedDate);
                } else if (widget.onPressed != null) {
                  print("일반 pressed일때 ");
                  widget.onPressed?.call(selectedDate);
                }
                
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
