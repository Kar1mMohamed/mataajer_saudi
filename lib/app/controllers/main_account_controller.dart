import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/database/shop_fav.dart';

class MainAccountController extends GetxController {
  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;
  bool? isShopOwner;

  List<ShopModule> getFavShops(List<ShopModule> shops) {
    List<ShopFavHive> favShopsHive = ShopFavHive.box.values.toList();

    List<ShopModule> favShops = [];

    for (var e in favShopsHive) {
      if (shops.any((element) => element.uid == e.uid)) {
        favShops.add(shops.firstWhere((element) => element.uid == e.uid));
      }
    }

    return favShops;
  }

  void addShopToFav(ShopModule shop) {
    ShopFavHive.box.put(shop.uid, ShopFavHive(shop.uid!, shop.name));
  }

  void removeShopFromFav(ShopModule shop) {
    ShopFavHive.box.delete(shop.uid);
  }
}
