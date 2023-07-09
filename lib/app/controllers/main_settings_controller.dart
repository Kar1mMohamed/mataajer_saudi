import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class MainSettingsController extends GetxController {
  ///
  /// ALL FUNCTIONS HERE NEED TO BE CALLED FROM SPLASH SCREEN
  ///
  static MainSettingsController find = Get.find();
  List<CategoryModule> mainCategories = [];
  List<ChooseSubscriptionModule> subscriptions = [];

  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;

  // bool? loginRememberMe;

  Future<void> getCategories() async {
    try {
      mainCategories = await FirebaseFirestore.instance
          .collection('categories')
          .get()
          .then((value) {
        return value.docs
            .map((e) => CategoryModule.fromMap(e.data(), e.id))
            .toList();
      });

      log('mainCategories: $mainCategories');
    } catch (e) {
      log(e);
    }
  }

  Future<void> getSubscriptions() async {
    try {
      subscriptions = await FirebaseFirestore.instance
          .collection('subscriptions')
          .get()
          .then((value) {
        return value.docs
            .map((e) => ChooseSubscriptionModule.fromMap(e.data(), uid: e.id))
            .toList();
      });

      log('subscriptions: $subscriptions');
    } catch (e) {
      log(e);
    }
  }

  // void setLoginRememberMe() {
  //   loginRememberMe = GetStorage().read('loginRememberMe') ?? false;
  // }
}
