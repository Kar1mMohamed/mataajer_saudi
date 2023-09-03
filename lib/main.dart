import 'dart:async';
import 'dart:developer';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_popup_ads_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/controllers/online_now_controller.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
// import 'package:mataajer_saudi/app/helper/notitication_helper.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/translation/tr.dart';
import 'app/controllers/app_life_cycle_controller.dart';
import 'app/data/constants.dart';
import 'app/routes/app_pages.dart';
import 'database/helper/hive_helper.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
  try {
    log('data: ${message.data.toString()}');
  } catch (e) {
    log('_firebaseMessagingBackgroundHandler: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await HiveHelper.initHive();
  await CloudMessaging.initialize();
  await FirebaseAppCheck.instance.activate(
    androidProvider: Constants.isDebug
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  // FirebaseFirestore.setLoggingEnabled(false);
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
          // --------------- //
          log('current date: ${DateTime.now().millisecondsSinceEpoch}');
          log('current date +12: ${DateTime.now().add(const Duration(days: 12)).millisecondsSinceEpoch}');
          // --------------- //

          // var allOffers =
          //     await FirebaseFirestoreHelper.instance.getOffers(forAdmin: true);
          // var allCategories = Get.find<MainSettingsController>().mainCategories;

          // var batch = FirebaseFirestore.instance.batch();

          // for (var offer in allOffers) {
          //   var randomCategory =
          //       allCategories[math.Random().nextInt(allCategories.length)];

          //   offer.categoryUIDs = [randomCategory.uid!];

          //   log('updating offer: ${offer.uid} with category: ${randomCategory.name}');

          //   batch.update(
          //       FirebaseFirestore.instance.collection('offers').doc(offer.uid),
          //       offer.toMap());
          // }

          // await batch.commit();

          // MainSettingsController mainSettings =
          //     Get.find<MainSettingsController>();
          // var allCategories = await mainSettings.getCategories();
          // var allSubscriptions = await mainSettings.getSubscriptions();
          // var allAdmins = await mainSettings.getAdmins();
          // var appSettings = AppSettings(
          //     categories: allCategories,
          //     subscriptions: allSubscriptions,
          //     admins: allAdmins);

          // log('appSettings: ${appSettings.toJson()}');

          // await FirebaseFirestoreHelper.instance.setAppSettings(appSettings);
          // final offer = await FirebaseFirestoreHelper.instance
          //     .getOffers()
          //     .then((value) => value.first);

          // List<OfferModule> newoffers = [];
          // var allCategories =
          //     await Get.find<MainSettingsController>().getCategories();
          // for (var category in allCategories) {
          //   var newOffer = offer.copyWith(
          //     categoryUIDs: [category.uid!],
          //   );
          //   newoffers.add(newOffer);
          // }

          // for (var offer in newoffers) {
          //   await FirebaseFirestoreHelper.instance.addOffer(offer);
          // }

          // var banner = BannerModule(
          //   title: 'Vision',
          //   image:
          //       'https://firebasestorage.googleapis.com/v0/b/mataajer-saudi.appspot.com/o/homeBanner_new.jpg?alt=media&token=c3f42bee-1f60-4d98-9bdd-576986667482',
          //   url: 'https://www.vision-log.com/',
          // );

          // await FirebaseFirestore.instance
          //     .collection('app')
          //     .doc('home_view')
          //     .update({
          //   'banners': [banner.toMap()]
          // });

          // var list = [
          //   // "الكترونيات (6)",
          //   "الهواتف الذكية ومستلزماتها",
          //   "الكمبيوترات والأجهزة المحمولة وملحقاتها",
          //   "الكاميرات الرقمية وملحقاتها",
          //   "التلفزيونات",
          //   "السماعات",
          //   "الاجهزة المنزلية",
          //   // "مستلزمات المنزل (3)",
          //   "حدائق ونباتات",
          //   "اثاث",
          //   "مواد بناء",
          //   // "ازياء (7)",
          //   "ازياء نسائية",
          //   "ازياء اطفال",
          //   "عبايات",
          //   "جوارب",
          //   "ازياء رجالية",
          //   "الأحذية",
          //   "الثياب والأشمغة",
          //   // "مجوهرات (1)",
          //   "مجوهرات",
          //   // "مستحضرات التجميل والعناية (6)",
          //   "مكياج",
          //   "عدسات",
          //   "العناية الشخصية",
          //   "رموش",
          //   "عطور",
          //   "العود والبخور",
          //   // "الاكسسوارات و الهدايا (6)",
          //   "نظارات",
          //   "ساعات",
          //   "محافظ",
          //   "ورد",
          //   "التوزيعات",
          //   "البروشات والملصقات",
          //   // "الفنون والموسيقى (3)",
          //   "لوح فنية",
          //   "الحرف والاعمال اليدوية",
          //   "الادوات الموسيقية",
          //   // "الكتب والتعليم (5)",
          //   "الكتب والروايات",
          //   "قرطاسية",
          //   "الدورات التعليمية",
          //   "قصص مصورة / مانجا",
          //   "موارد مكتبية",
          //   // "خدمات (5)",
          //   "التصميم والطباعة",
          //   "السفر والسياحة والحجوزات",
          //   "الاستشارات",
          //   "التصوير",
          //   "صيانة الاجهزة",
          //   // "صحة ولياقة (4)",
          //   "مكملات غذائية",
          //   "أطعمة ومنتجات صحية",
          //   "اجهزة ومستلزمات رياضية",
          //   "صيدلية",
          //   // "المطاعم والمقاهي (4)",
          //   "فودترك",
          //   "مطعم",
          //   "مقهى",
          //   "مكائن القهوة ومستلزماتها",
          //   // "أغذية وتموينات (6)",
          //   "أغذية مبردة",
          //   "مشروبات",
          //   "مستلزمات غذائية",
          //   "عسل",
          //   "تمور",
          //   "حلويات",
          //   // "حيوانات (3)",
          //   "حيوانات اليفة",
          //   "أطعمة حيوانات",
          //   "مسلتزمات حيوانات",
          //   // "سيارات (1)",
          //   "سيارات",
          //   // "منتجات رقمية (5)",
          //   "بطائق رقمية",
          //   "رخص برامج/العاب",
          //   "أفلام ومسلسلات",
          //   "العاب الفيديو",
          //   "اشتراكات",
          //   // "جمعية خيرية (4)",
          //   "تبرعات",
          //   "الصدقة والزكاة",
          //   "الدعوة والإرشاد",
          //   "كفالة الايتام",
          //   // "العاب (4)",
          //   "العاب الاطفال",
          //   "العاب الطاولة",
          //   "العاب الحدائق",
          //   "مجسمات"
          // ];

          // var categoryModules = list
          //     .map((e) => CategoryModule(
          //           name: e,
          //         ))
          //     .toList();

          // for (var category in categoryModules) {
          //   await FirebaseFirestore.instance
          //       .collection('categories')
          //       .add(category.toMap());
          // }

          // final adminModule = ShopModule(
          //   name: 'Mataajer',
          //   email: 'admin@mataajer-ksa.com',
          //   description: 'admin',
          //   image: '',
          //   categoriesUIDs: [],
          //   userCategory: 'admin-0',
          // );

          // await FirebaseFirestoreHelper.instance
          //     .addShop(adminModule, 'LLO8B1wNBkUgWEwyi8RKmapTOcs1');

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
          //   isCanSendTwoNotification: false,
          //   isCanSendFourNotification: false,
          // );
          // final second = ChooseSubscriptionModule(
          //   name: 'الفضية',
          //   yearlyPrice: 100,
          //   monthlyPrice: 10,
          //   isPublishable: true,
          //   isStatic: true,
          //   isTwoPopUpAdsMonthly: true,
          //   isFourPopUpAdsMonthly: false,
          //   isCanSendTwoNotification: true,
          //   isCanSendFourNotification: false,
          // );
          // final third = ChooseSubscriptionModule(
          //   name: 'الذهبية',
          //   yearlyPrice: 100,
          //   monthlyPrice: 10,
          //   isPublishable: true,
          //   isStatic: true,
          //   isTwoPopUpAdsMonthly: true,
          //   isFourPopUpAdsMonthly: true,
          //   isCanSendTwoNotification: false,
          //   isCanSendFourNotification: true,
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
    Get.lazyPut<OnlineNowController>(() => OnlineNowController(), fenix: true);
    Get.lazyPut<AppLifeCylceController>(() => AppLifeCylceController(),
        fenix: true);
    Get.put<MainSettingsController>(MainSettingsController(), permanent: true);
    Get.lazyPut<MainPermisionsController>(() => MainPermisionsController(),
        fenix: true);
    Get.lazyPut<MainAccountController>(() => MainAccountController(),
        fenix: true);
    Get.lazyPut<MainPopupAdsController>(() => MainPopupAdsController(),
        fenix: true);
    Get.lazyPut<MainNotificationController>(() => MainNotificationController(),
        fenix: true);
  }
}
