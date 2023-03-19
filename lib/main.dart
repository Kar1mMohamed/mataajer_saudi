import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/translation/tr.dart';
import 'package:mataajer_saudi/firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Mataajer",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        themeMode: ThemeMode.light,
        theme: MataajerTheme.light,
        initialBinding: _InitialBindings(),
        translations: Translation(),
        locale: const Locale('ar', 'SA'),
        onInit: () async {},
      ),
    );
  }
}

class _InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MainPermisionsController>(MainPermisionsController(),
        permanent: true);
    Get.lazyPut<MainAccountController>(() => MainAccountController(),
        fenix: true);
    Get.lazyPut<MainNotificationController>(() => MainNotificationController(),
        fenix: true);
  }
}
