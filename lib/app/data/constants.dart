class Constants {
  Constants._();
  static List<String> categoriesString = [
    'ملابس واحذية',
    'اكسسوارات',
    'اجهزة الكترونية',
    'اثاث وديكور',
    'سيارات',
    'اتصالات وانترنت',
  ];

  static String convertDateToTimeString(DateTime date) {
    bool isAM = date.hour < 12;
    String timeTitle = isAM ? 'صباحا' : 'مساء';
    String hour =
        date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString();

    return '$hour:${date.minute} $timeTitle';
  }
}
