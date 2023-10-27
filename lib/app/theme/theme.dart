import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mataajer_saudi/app/widgets/shop_animated_widget.dart';

class MataajerTheme {
  static TextStyle tajawalTextStyle = const TextStyle(fontFamily: 'Tajawal');

  static TextStyle drawerTextStyle = tajawalTextStyle.copyWith(
    fontWeight: FontWeight.w500,
    color: mainColor,
  );
  // static Widget loadingWidget({double? size}) =>
  //     SpinKitCircle(color: mainColor, size: size ?? 75);

  static Widget get loadingWidget => const ShopAnimatedWidget();

  static TextStyle introTextStyle = tajawalTextStyle.copyWith(
    fontSize: 15,
    color: const Color(0xFF6c757d),
    fontWeight: FontWeight.w600,
  );
  static TextStyle mainTextStyle = tajawalTextStyle.copyWith(
    fontSize: 18,
    color: const Color.fromARGB(255, 3, 0, 6),
    fontWeight: FontWeight.w700,
  );
  static TextStyle bahijTextStyle = const TextStyle(fontFamily: 'Bahij');
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: tajawalTextStyle.copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyMedium: tajawalTextStyle.copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    titleMedium: tajawalTextStyle.copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    titleSmall: tajawalTextStyle.copyWith(
      fontSize: 17.0,
      color: Colors.black,
    ),
    displayLarge: tajawalTextStyle.copyWith(
      fontSize: 31.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: tajawalTextStyle.copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: tajawalTextStyle.copyWith(
      fontSize: 19.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      decoration: TextDecoration.none,
    ),
    headlineMedium: tajawalTextStyle.copyWith(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      decoration: TextDecoration.none,
    ),
    headlineSmall: tajawalTextStyle.copyWith(
      fontSize: 19.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      decoration: TextDecoration.none,
    ),
    titleLarge: tajawalTextStyle.copyWith(
      fontSize: 19.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
  static ThemeData get light => ThemeData(
        dialogBackgroundColor: mainBackgroundColor,
        primaryColor: mainColor,
        brightness: Brightness.light,
        shadowColor: Colors.transparent,
        scaffoldBackgroundColor: mainBackgroundColor,
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: mainColor),
          color: Colors.white,
          centerTitle: true,
          titleTextStyle: tajawalTextStyle.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: mainColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.white, backgroundColor: mainColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: bottomBackgroundColor,
          selectedLabelStyle: bahijTextStyle,
          unselectedLabelStyle: bahijTextStyle,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(mainColor),
          overlayColor: MaterialStateProperty.all(mainColor),
          splashRadius: 0.0,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        textTheme: lightTextTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: mainGreyColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1, color: mainGreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1, color: mainGreyColor),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: mainColorSwatch)
            .copyWith(background: Colors.transparent)
            .copyWith(background: Colors.white),
        drawerTheme: const DrawerThemeData(
          elevation: 1,
          backgroundColor: Colors.white,
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
        ),
      );

  static const Color mainBackgroundColor = Color(0xFFF5F5F5);

  static const Color yellowColor = Color(0xFFFF9900);
  static const Color orangeColor = Color(0xFFE29336);
  static const Color blackColor = Color(0xFF000000);
  static const Color greyColor = Color(0xFFf8f9fa);
  static const Color darkColor = Color.fromARGB(255, 35, 35, 35);

  static const Color mainColor = Color(_mainColorswatchPrimaryValue);
  static const Color mainColorDarken = Color(0xFFBA68C8);
  static const Color mainColorLighten = Color(0xFFB786CA);
  static const Color seconderyColor = Color(0xFF5CD5C4);
  static Color background1Color = const Color(0xFFf8f9fa);

  static Color mainGreyColor = const Color(0xFFF5F5F5);
  static Color secondGreyColor = const Color(0xFF747474);
  static Color backArrowFillColor = const Color(0xFF626262);

  static Color switchColor = const Color(0xFFAD7BC4);

  static Color bottomBackgroundColor = const Color(0xFFFAFAFA);

  static const MaterialColor mainColorSwatch = MaterialColor(
    _mainColorswatchPrimaryValue,
    <int, Color>{
      50: Color(_mainColorswatchPrimaryValue),
      100: Color(_mainColorswatchPrimaryValue),
      200: Color(_mainColorswatchPrimaryValue),
      300: Color(_mainColorswatchPrimaryValue),
      400: Color(_mainColorswatchPrimaryValue),
      500: Color(_mainColorswatchPrimaryValue),
      600: Color(_mainColorswatchPrimaryValue),
      700: Color(_mainColorswatchPrimaryValue),
      800: Color(_mainColorswatchPrimaryValue),
      900: Color(_mainColorswatchPrimaryValue),
    },
  );
  static const int _mainColorswatchPrimaryValue = 0xFFAD7BC4;
}
