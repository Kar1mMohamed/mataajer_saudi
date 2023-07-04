import 'dart:async';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/pop_up_ad_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/popup_ads.dart';

class MainPopupAdsController extends GetxController {
  List<PopUpAdModule> ads = [];

  Future<void> init() async {
    ads = await FirebaseFirestoreHelper.instance.getPopUpAds();
    update();
  }

  void initTimer() {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      await init();
      PopUpAdsFunctions.showPopUpAd(ads: ads);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await init();
    initTimer();
  }
}
