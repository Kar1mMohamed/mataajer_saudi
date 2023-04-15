import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/database/shop_fav.dart';

class MainAccountController extends GetxController {
  static MainAccountController find = Get.find();
  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;
  bool isShopOwner = false;

  List<AdModule> getFavShops(List<AdModule> ads) {
    List<ShopFavHive> favShopsHive = ShopFavHive.box.values.toList();

    List<AdModule> favAds = [];

    for (var e in favShopsHive) {
      if (ads.any((element) => element.shopUID == e.uid)) {
        final ad = ads.firstWhere((element) => element.shopUID == e.uid);

        favAds.add(ad);
      }
    }

    return favAds;
  }

  void addShopToFav(AdModule shop) {
    ShopFavHive.box.put(shop.uid, ShopFavHive(shop.uid!, shop.name));
  }

  void removeShopFromFav(AdModule shop) {
    ShopFavHive.box.delete(shop.uid);
  }
}
