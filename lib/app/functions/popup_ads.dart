import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_popup_ads_controller.dart';
import 'package:mataajer_saudi/app/data/modules/pop_up_ad_module.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/app/widgets/loading_image.dart';

class PopUpAdsFunctions {
  PopUpAdsFunctions._();

  static void showPopUpAd({List<PopUpAdModule>? ads}) async {
    log('showPopUpAd: ${ads?.length}');
    bool isUser = FirebaseAuth.instance.currentUser != null;
    if (isUser) {
      log('showPopUpAd: user signed in');
      return;
    }

    log('showPopUpAd: user not signed in');
    ads ??= Get.find<MainPopupAdsController>().ads;
    if (ads.isEmpty) {
      return;
    }
    final randomIndex = math.Random().nextInt(ads.length);
    final ad = ads[randomIndex];
    log('showPopUpAd: randomIndex: $randomIndex');
    log('showPopUpAd: ads: ${ads.length}');
    // show ad
    log('showPopUpAd: showing ad ${ad.uid}');
    await Get.dialog(
      Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: Get.context!.height * 0.5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              InkWell(
                onTap: () {
                  URLLauncherFuntions.launchURL(ad.url!);
                },
                child: Center(
                  child: LoadingImage(src: ad.image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    ad.addView();
  }
}
