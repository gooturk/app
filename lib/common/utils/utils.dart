import 'package:gooturk/common/const/data.dart';

class Utils {
  static DateTime truncateToTimeUnit(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      (date.minute / RESERVATION_TIME_UNIT).round() * RESERVATION_TIME_UNIT,
    );
  }

  static getButtonNameFromEnum<T>({
    required T enumValue,
    required Map<T, String> map,
  }) {
    return map[enumValue] ?? '';
  }

  static bool isDifferentDay(DateTime formerDate, DateTime latterDate) {
    return formerDate.year != latterDate.year ||
        formerDate.month != latterDate.month ||
        formerDate.day != latterDate.day;
  }

  static String getYYYYMMDDfromDateTime(DateTime dateTime) {
    return "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
  }

  static String getYYYYMMDDHHMMfromDateTimeWithKorean(
    DateTime dateTime, {
    bool showHHMM = false,
  }) {
    return "${dateTime.year}년 ${dateTime.month.toString().padLeft(2, '0')}월 ${dateTime.day.toString().padLeft(2, '0')}일 ${showHHMM ? getHHMMfromDateTime(dateTime) : ''}";
  }

  static String getHHMMfromDateTime(DateTime dateTime) {
    return "${dateTime.hour}시${dateTime.minute == 0 ? '' : ' ${dateTime.minute}분'}";
  }

  static String getHHMMAmountfromDuration(Duration duration) {
    final minute = duration.inMinutes % 60;
    if (duration.inHours == 0) {
      return "$minute분";
    }
    return "${duration.inHours}시간${minute == 0 ? '' : ' $minute분'}";
  }

  static String getMMSSfromDateSeconds(int timeLeftInSeconds) {
    int minutes = timeLeftInSeconds ~/ 60;
    int seconds = timeLeftInSeconds % 60;
    return "${minutes < 10 ? '0' : ''}$minutes : ${seconds < 10 ? '0' : ''}$seconds";
  }
}
