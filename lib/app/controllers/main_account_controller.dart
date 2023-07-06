import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/database/shop_fav.dart';

class MainAccountController extends GetxController {
  static MainAccountController find = Get.find();
  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;
  bool isShopOwner = false;

  List<AdModule> getFavAds(List<AdModule> ads) {
    var favShopsHive = ShopFavHive.hiveBox.values;
    final favAds =
        ads.where((ad) => favShopsHive.any((e) => e.uid == ad.uid)).toList();

    return favAds;
  }

  List<ShopModule> getFavShops(List<ShopModule> shops) {
    var favShopsHive = ShopFavHive.hiveBox.values;
    final favShops = shops
        .where((shop) => favShopsHive.any((e) => e.uid == shop.uid))
        .toList();
    return favShops;
  }

  void addAdToFav(ShopModule shop) {
    ShopFavHive.hiveBox.put(shop.uid!, ShopFavHive(shop.uid!, shop.name));
    log('added to fav: ${shop.uid}');
  }

  void removeAdFromFav(ShopModule shop) {
    ShopFavHive.hiveBox.delete(shop.uid!);
    log('removed from fav: ${shop.name}');
  }
}
