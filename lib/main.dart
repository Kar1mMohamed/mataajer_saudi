import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/functions/hive.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/translation/tr.dart';
import 'package:mataajer_saudi/firebase_options.dart';
import 'app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveHelper.initHive();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await CloudMessaging.initialize();
  runApp(const MyApp());
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
        onInit: () async {
          // final subScription = SubscriptionModule(
          //     uid: 'dsfr23rjkndfg',
          //     from: DateTime.now(),
          //     to: DateTime.now().add(Duration(days: 30)));

          // await FirebaseFirestore.instance
          //     .collection('shops')
          //     .doc('K0ASL50rI6Y3VyuxOvEg70AgUw42')
          //     .collection('subscriptions')
          //     .add(subScription.toMap());

          /// ADD CATEGORIES FROM CONTANTS CATEGORIES TO FIREBASE
          // for (var e in Constants.categoriesString) {
          //   final category = CategoryModule(name: e);
          //   await FirebaseFirestore.instance
          //       .collection('categories')
          //       .add(category.toMap());
          // }

          // --------------- //

          await FirebaseAuth.instance.signOut();
          // for (var i = 1; i < 4; i++) {
          //   final model = ChooseSubscriptionModule(
          //     name: i == 1
          //         ? 'العادية'
          //         : i == 2
          //             ? 'الفضية'
          //             : 'الذهبية',
          //     monthlyPrice: 12,
          //     yearlyPrice: 120,
          //   );

          //   await FirebaseFirestore.instance
          //       .collection('subscriptions')
          //       .doc('$i')
          //       .set(model.toMap());
          // }
        },
      ),
    );
  }
}

class _InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MainSettingsController>(MainSettingsController(), permanent: true);
    Get.put<MainPermisionsController>(MainPermisionsController(),
        permanent: true);
    Get.put<MainAccountController>(MainAccountController(), permanent: true);
    Get.lazyPut<MainNotificationController>(() => MainNotificationController(),
        fenix: true);
  }
}
