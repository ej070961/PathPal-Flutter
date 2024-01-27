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
  final VoidCallback? onPressed;

  ModalBottomSheet(
      {required this.timeTitle,
      required this.nextButtonTitle,
      required this.onPressed});

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();

  static show(BuildContext context,
      {required String timeTitle,
      required String nextButtonTitle,
      required VoidCallback onPressed}) {
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
              onPressed: onPressed);
        });
  }
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime initialDateTime = FormatTime.formatCheckMinute(now);

    return Container(
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
                '${widget.timeTitle}     ${DateFormat.yMd('ko_KR').add_Hm().format(now)}',
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
                onDateTimeChanged: (DateTime newDate) {},
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
              title: "${widget.nextButtonTitle}",
              onPressed: widget.onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
