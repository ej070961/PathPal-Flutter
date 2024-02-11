import 'package:flutter/material.dart';
import 'package:pathpal/colors.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pathpal/widgets/modal_bottom_sheet.dart';
import 'package:pathpal/models/car_state.dart';

class DepartureTimeWidget extends StatefulWidget {
  DateTime departureTime;

  DepartureTimeWidget(
    {required this.departureTime,
    Key? key
    }) : super(key: key);
  // DepartureTimeWidget({super.key});

  @override
  _DepartureTimeWidgetState createState() => _DepartureTimeWidgetState();
}

class _DepartureTimeWidgetState extends State<DepartureTimeWidget> {
  String? formattedDateTime;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null).then((_) {
      updateFormattedDateTime();
    });
  }

  void updateFormattedDateTime() {
    setState(() {
      formattedDateTime = DateFormat('M/d (E) HH:mm', 'ko_KR')
          .format(widget.departureTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: mainAccentColor,
                        ) ??
                    TextStyle(),
              ),
              onTap: () {
                ModalBottomSheet.show(
                  context,
                  timeTitle: '출발시각',
                  nextButtonTitle: '선택완료',
                  initialDateTime: widget.departureTime,
                  onPressed: (DateTime selectedDate) {
                    print('변경 전 departureTime: ${widget.departureTime}');
                    setState(() {
                      print('변경');
                      widget.departureTime = selectedDate;
                    });
                    print('변경 후 departureTime: ${widget.departureTime}');
                    // Update the formattedDateTime or any other necessary updates
                    updateFormattedDateTime();
                  },
                );
              }),
        ],
      ),
    );
  }
}
