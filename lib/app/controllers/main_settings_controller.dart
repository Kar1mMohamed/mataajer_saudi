import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/app/app_settings.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class MainSettingsController extends GetxController {
  ///
  /// ALL FUNCTIONS HERE NEED TO BE CALLED FROM SPLASH SCREEN
  ///
  static MainSettingsController find = Get.find();

  AppSettings? appSettings;

  List<CategoryModule> mainCategories = [];
  List<ChooseSubscriptionModule> subscriptions = [];
  List<String> admins = [];

  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;

  /// THIS METHOD IS TO AVOID APPLE STORE IN-APP PURCHASE
  bool isVersionRelease = false;

  // bool? loginRememberMe;

  // Future<List<CategoryModule>> getCategories() async {
  //   try {
  //     mainCategories = await FirebaseFirestore.instance
  //         .collection('categories')
  //         .get()
  //         .then((value) {
  //       return value.docs
  //           .map((e) => CategoryModule.fromMap(e.data(), uid: e.id))
  //           .toList();
  //     });

  //     log('mainCategories: $mainCategories');
  //     return mainCategories;
  //   } catch (e) {
  //     log(e);
  //     rethrow;
  //   }
  // }

  // Future<List<ChooseSubscriptionModule>> getSubscriptions() async {
  //   try {
  //     var subscriptions = await FirebaseFirestore.instance
  //         .collection('subscriptions')
  //         .get()
  //         .then((value) {
  //       return value.docs
  //           .map((e) => ChooseSubscriptionModule.fromMap(e.data(), uid: e.id))
  //           .toList();
  //     });

  //     this.subscriptions = subscriptions;

  //     log('subscriptions: $subscriptions');

  //     return subscriptions;
  //   } catch (e) {
  //     log(e);
  //     rethrow;
  //   }
  // }

  // Future<List<String>> getAdmins() async {
  //   try {
  //     var admins = await FirebaseFirestore.instance
  //         .collection('settings')
  //         .doc('app')
  //         .get()
  //         .then((value) => value.data()?['admins'] as List<dynamic>)
  //         .then((value) => value.map((e) => e.toString()).toList());

  //     this.admins = admins;

  //     log('admins: $admins');

  //     return admins;
  //   } catch (e) {
  //     log('getAdmins: $e');
  //     rethrow;
  //   }
  // }

  // void setLoginRememberMe() {
  //   loginRememberMe = GetStorage().read('loginRememberMe') ?? false;
  // }

  Future<AppSettings> getAppSettings() async {
    try {
      var appSettings = await FirebaseFirestore.instance
          .collection('settings')
          .doc('app')
          .get()
          .then((value) =>
              AppSettings.fromMap(value.data() as Map<String, dynamic>));

      this.appSettings = appSettings;

      mainCategories = appSettings.categories;
      subscriptions = appSettings.subscriptions;
      admins = appSettings.admins;

      isVersionRelease = appSettings.isVersionRelease ?? false;

      log('appSettings: $appSettings');

      return appSettings;
    } catch (e) {
      log('getAppSettings: $e');
      rethrow;
    }
  }

  // /// THIS METHOD IS TO AVOID APPLE STORE IN-APP PURCHASE
  // Future<void> checkAppVersion() async {
  //   if (!Platform.isIOS) return;
  //   try {
  //     var res =
  //         await http.get(Uri.parse('https://matajer-ksa.com/app/version.php'));

  //     if (res.statusCode == 200) {
  //       var body = res.body;
  //       var codeunits = body.codeUnits;

  //       if (codeunits.length == 28 && codeunits.last == 41) {
  //         isVersionRelease = true;
  //       }
  //     }
  //   } catch (e) {
  //     log('checkAppVersion: $e');
  //   } finally {
  //     log('isVersionRelease: $isVersionRelease');
  //   }
  // }
}
