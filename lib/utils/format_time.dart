import 'package:intl/intl.dart';

class FormatTime {
  static String formatTime(DateTime time) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');

    // 오늘 날짜와 time의 날짜를 비교
    if (formatter.format(now) == formatter.format(time)) {
      // 날짜가 오늘과 같다면 '오늘'을 붙이고 시간을 표시
      return '오늘 ' + DateFormat('HH:mm').format(time);
    } else {
      // 날짜가 오늘과 다르면 날짜와 시간을 표시
      return DateFormat('MM월 dd일 HH:mm').format(time);
    }
  }

  static DateTime formatCheckMinute(DateTime now) {
    return DateTime(now.year, now.month, now.day, now.hour, now.minute ~/ 5 * 5);
}

}