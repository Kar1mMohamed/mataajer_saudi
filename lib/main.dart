import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_popup_ads_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/translation/tr.dart';
import 'package:mataajer_saudi/database/helper/hive_helper.dart';
import 'package:mataajer_saudi/database/notification.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
  await NotificationModule.openBox;
  final notificationModule = NotificationModule(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    data: message.data,
    date: DateTime.now(),
    senderUserImage: message.data['url'],
    senderUserUID: message.data['userUID'],
  );
  await NotificationModule.hiveBox.add(notificationModule);
  log('added notificationModule: ${notificationModule.toMap()}');
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveHelper.initHive();
  await CloudMessaging.initialize();
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
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
        smartManagement: SmartManagement.full,
        // builder: (context, child) {
        //   return CheckoutWebview(
        //     'https://initail-exp.com/',
        //     'mataajer://m.mataajer-sa.com/payments-redirect/',
        //     'https://fail.com/',
        //     'https://cancel.com/',
        //     onPaymentSuccess: (query) {
        //       log('success query: $query');
        //     },
        //   );
        // },
        onInit: () async {
          log('current date: ${DateTime.now().millisecondsSinceEpoch}');
          log('current date +12: ${DateTime.now().add(const Duration(days: 12)).millisecondsSinceEpoch}');
          // --------------- //

          // final popUpAds = List.generate(
          //     3,
          //     (index) => PopUpAdModule(
          //           title: 'Test $index',
          //           description: 'Descripton $index',
          //           isVisible: true,
          //           validTill: DateTime.now().add(Duration(days: 12)),
          //           image:
          //               'https://c8.alamy.com/comp/H3D3H0/small-indian-shop-sells-merchandise-per-single-unit-H3D3H0.jpg',
          //         ));

          // for (var ad in popUpAds) {
          //   log('added ad ');
          //   await FirebaseFirestoreHelper.instance.addPopUpAd(ad);
          // }

          // await FirebaseAuth.instance.signOut();

          // --------------- //

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

          // final first = ChooseSubscriptionModule(
          //   name: 'العادية',
          //   yearlyPrice: 100,
          //   monthlyPrice: 10,
          //   isPublishable: true,
          //   isStatic: false,
          //   isTwoPopUpAdsMonthly: false,
          //   isFourPopUpAdsMonthly: false,
          //   isCanSendNotification: false,
          // );
          // final second = ChooseSubscriptionModule(
          //   name: 'الفضية',
          //   yearlyPrice: 100,
          //   monthlyPrice: 10,
          //   isPublishable: true,
          //   isStatic: true,
          //   isTwoPopUpAdsMonthly: true,
          //   isFourPopUpAdsMonthly: false,
          //   isCanSendNotification: false,
          // );
          // final third = ChooseSubscriptionModule(
          //   name: 'الذهبية',
          //   yearlyPrice: 100,
          //   monthlyPrice: 10,
          //   isPublishable: true,
          //   isStatic: true,
          //   isTwoPopUpAdsMonthly: true,
          //   isFourPopUpAdsMonthly: true,
          //   isCanSendNotification: true,
          // );
          // final models = [first, second, third];
          // for (var i = 0; i < 3; i++) {
          //   var count = i + 1;
          //   log('add subscription index: $i');
          //   await FirebaseFirestore.instance
          //       .collection('subscriptions')
          //       .doc('$count')
          //       .set(models[i].toMap());
          // }

          // --------------- //

          // List<NotificationModule> notifications = List.generate(
          //   10,
          //   (index) {
          //     log('add notification index: $index');
          //     return NotificationModule(
          //       title: 'title $index',
          //       body: 'body $index',
          //       data: {'data': 'data $index'},
          //       date: DateTime.now(),
          //     );
          //   },
          // );

          // await NotificationModule.hiveBox.addAll(notifications);
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

    Get.put<MainPopupAdsController>(MainPopupAdsController(), permanent: true);
  }
}
