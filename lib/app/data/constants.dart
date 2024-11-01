import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Constants {
  Constants._();
  static String unKnownPersonImageURL =
      'https://firebasestorage.googleapis.com/v0/b/mataajer-saudi.appspot.com/o/Unknown_person.jpg?alt=media&token=b8b77259-f2fb-447b-ace2-a5b35a90ec9d';

  static List<String> categoriesString = [
    'ملابس واحذية',
    'اكسسوارات',
    'اجهزة الكترونية',
    'اثاث وديكور',
    'سيارات',
    'اتصالات وانترنت',
  ];

  static String convertDateToTimeString(DateTime date) {
    final formateNumber = NumberFormat('00');
    bool isAM = date.hour < 12;
    String timeTitle = isAM ? 'صباحا' : 'مساء';
    int hour = date.hour > 12 ? (date.hour - 12) : date.hour;

    return '${formateNumber.format(hour)}:${formateNumber.format(date.minute)} $timeTitle';
  }

  static String? convertDateToDateString(DateTime? date) {
    if (date == null) {
      return null;
    }
    final formateNumber = NumberFormat('00');

    return '${formateNumber.format(date.day)}/${formateNumber.format(date.month)}/${date.year} ${convertDateToTimeString(date)}';
  }

  static const List<String> admins = [
    '0zapKo4rAjhMxC9GFwChmYxKOP23',
    't8scmFWTBjhk4srk3bcTTRfw4fM2'
  ];

  static bool get isDebug => kDebugMode;
}
