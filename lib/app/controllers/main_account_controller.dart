import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/database/shop_fav.dart';

class MainAccountController extends GetxController {
  static MainAccountController find = Get.find();
  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;
  bool isShopOwner = false;

  List<AdModule> getFavShops(List<AdModule> ads) {
    List<ShopFavHive> favShopsHive = ShopFavHive.hiveBox.values.toList();
    final favAds = favShopsHive
        .map((e) => ads.firstWhere((element) => element.uid == e.uid))
        .toList();
    return favAds;
  }

  void addAdToFav(AdModule ad) {
    ShopFavHive.hiveBox.put(ad.uid!, ShopFavHive(ad.uid!, ad.name));
    log('added to fav: ${ad.uid}');
  }

  void removeAdFromFav(AdModule ad) {
    ShopFavHive.hiveBox.delete(ad.uid!);
    log('removed from fav: ${ad.name}');
  }
}
