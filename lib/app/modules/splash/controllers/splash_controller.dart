import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import '../../../utils/log.dart';
import 'dart:math' as math;

class SplashController extends GetxController {
  final mainSettingsController = Get.find<MainSettingsController>();

  bool loading = false;

  Future<void> init() async {
    try {
      updateLoading();

      // await mainSettingsController.getAdmins();
      // await mainSettingsController.getCategories();
      // await mainSettingsController.getSubscriptions();
      await mainSettingsController.getAppSettings();

      // final offer = await FirebaseFirestoreHelper.instance
      //     .getOffers()
      //     .then((value) => value.first);

      // List<OfferModule> newoffers = [];
      // var allCategories = await Get.find<MainSettingsController>()
      //     .getAppSettings()
      //     .then((value) => value.categories);
      // for (var category in allCategories) {
      //   var newOffer = offer.copyWith(
      //     categoryUIDs: [category.uid!],
      //   );
      //   newoffers.add(newOffer);
      // }

      // for (var offer in newoffers) {
      //   await FirebaseFirestoreHelper.instance.addOffer(offer);
      // }

      ///

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

      Get.offAndToNamed(Routes.ON_BARDING); // REAL INITAL ROUTE
    } catch (e) {
      log(e);
      KSnackBar.error(e.toString());
    }
  }

  void updateLoading() {
    loading = !loading;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await init();
  }
}
