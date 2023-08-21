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
      var subscriptions = await FirebaseFirestore.instance
          .collection('subscriptions')
          .get()
          .then((value) {
        return value.docs
            .map((e) => ChooseSubscriptionModule.fromMap(e.data(), uid: e.id))
            .toList();
      });

      this.subscriptions = subscriptions;

      log('subscriptions: $subscriptions');
    } catch (e) {
      log(e);
    } finally {
      update();
    }
  }

  // void setLoginRememberMe() {
  //   loginRememberMe = GetStorage().read('loginRememberMe') ?? false;
  // }
}
