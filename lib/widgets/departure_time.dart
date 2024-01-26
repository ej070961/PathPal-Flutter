import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DepartureTimeWidget extends StatefulWidget {
  final DateTime departureTime;

  DepartureTimeWidget({required this.departureTime, Key? key}) : super(key: key);

  @override
  _DepartureTimeWidgetState createState() => _DepartureTimeWidgetState();
}

class _DepartureTimeWidgetState extends State<DepartureTimeWidget> {
  late String formattedDateTime;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null).then((_) {
      setState(() {
        formattedDateTime =
            DateFormat('M/d (E) HH:mm', 'ko_KR').format(widget.departureTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        border: Border(
          bottom: BorderSide(
            color: gray200,
          ),
        ),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "출발 시각",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(width: 20),
              Text(
                formattedDateTime ?? '', // null 체크를 해줍니다.
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          GestureDetector(
            child: Text(
              "변경",
              style: TextStyle(
                color: mainAccentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
