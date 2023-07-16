import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/data/modules/pop_up_ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/app/widgets/loading_image.dart';
import 'package:mataajer_saudi/app/widgets/preview_shop_dialog.dart';

import '../../../functions/firebase_auth.dart';

class AdminActiveUsersController extends GetxController {
  RxInt get notificationCount =>
      Get.find<MainNotificationController>().notificationCount;

  bool loading = false;

  int pageIndex = 0;
  final pageController = PageController();
  final searchTextController = TextEditingController();

  List<ShopModule> allShops = [];
  List<ShopModule> activeShops = [];

  List<PopUpAdModule> allPopUpAds = [];
  List<OfferModule> offers = [];

  bool get isCurrentPageAllShops => pageIndex == 0;

  void updateAllShops() => update(['allShops']);

  void updateActiveShops() => update(['activeShops']);

  void Function(int) get onPageChanged => (int index) {
        pageIndex = index;
        if (pageIndex == 0) {
          getAllShops();
        } else {
          getActiveShops();
        }
        update();
      };

  Future<void> onRefresh() async {
    try {
      if (isCurrentPageAllShops) {
        await getAllShops();
      } else {
        await getActiveShops();
      }
    } catch (e) {
      log('onRefresh $e');
    }
  }

  Future<void> getAllShops() async {
    loading = true;
    updateAllShops();
    try {
      final shopsList =
          await FirebaseFirestoreHelper.instance.getShops(forAdmin: true);
      allShops = shopsList;

      await getAllPopUpAds();
      await getAllOffers();
    } catch (e) {
      log(e);
    } finally {
      sortShops();

      loading = false;
      updateAllShops();
    }
  }

  Future<void> getActiveShops() async {
    loading = true;
    updateActiveShops();
    try {
      final shopsList =
          await FirebaseFirestoreHelper.instance.getShops(forAdmin: true);
      activeShops = shopsList.where((element) => element.isVisible!).toList();
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      updateActiveShops();
    }
  }

  void updateShopVisibility(ShopModule module, int index) async {
    loading = true;
    isCurrentPageAllShops
        ? updateAllShopsCard(index)
        : updateActiveShopsCard(index);

    try {
      await FirebaseFirestoreHelper.instance.updateShopVisiblity(module);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      isCurrentPageAllShops
          ? updateAllShopsCard(index)
          : updateActiveShopsCard(index);
    }
  }

  void updateAllShopsCard(int index) {
    update(['allShopsCard-$index']);
  }

  void updateActiveShopsCard(int index) {
    update(['activeShopsCard-$index']);
  }

  Future<void> deleteShop(ShopModule module) async {
    loading = true;
    isCurrentPageAllShops ? updateAllShops() : updateActiveShops();
    try {
      await FirebaseAuthFuntions.deleteUsersWithoutLogin(token: module.token);
      await FirebaseFirestoreHelper.instance.deleteShop(module);
      isCurrentPageAllShops
          ? allShops.remove(module)
          : activeShops.remove(module);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      isCurrentPageAllShops ? updateAllShops() : updateActiveShops();
    }
  }

  void search(String text) {
    if (text.isEmpty) {
      isCurrentPageAllShops ? getAllShops() : getActiveShops();
    } else {
      isCurrentPageAllShops ? _searchAllShops(text) : _searchActiveShops(text);
    }
  }

  void _searchAllShops(String text) {
    allShops = allShops
        .where((element) =>
            element.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    updateAllShops();
  }

  void _searchActiveShops(String text) {
    activeShops = activeShops
        .where((element) =>
            element.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
    updateActiveShops();
  }

  void allShopAdsDialog(ShopModule shop) async {
    loading = true;
    update();

    final shops = await FirebaseFirestoreHelper.instance
        .getShops(forAdmin: true)
        .then((value) =>
            value.where((element) => element.uid == shop.uid).toList());

    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 300.w,
        height: 400.h,
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: shops.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListTile(
                title: Text(shops[index].cuponCode ?? ''),
                subtitle: Text(shops[index].description),
                trailing: IconButton(
                  onPressed: () async {
                    await FirebaseFirestoreHelper.instance
                        .deleteShop(shops[index]);
                    await getAllShops();
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Get.dialog(PreviewShopDialog(shop: shops[index]));
                  },
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
        ),
      ),
    ));

    loading = false;
    update();
  }

  void allShopPopUpAdsDialog(ShopModule shop) async {
    loading = true;
    update();

    final ads = await FirebaseFirestoreHelper.instance
        .getPopUpAds(forAdmin: true)
        .then((value) =>
            value.where((element) => element.shopUID == shop.uid).toList());

    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        height: Get.context!.height * 0.8,
        padding: const EdgeInsets.all(12.0),
        child: Builder(builder: (context) {
          if (ads.isEmpty) {
            return const Center(
              child: Text('لا يوجد اعلانات'),
            );
          }
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            child: SizedBox(
                              width: 300.w,
                              height: 300.h,
                              child: LoadingImage(
                                src: ads[index].image,
                              ),
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: NetworkImage(
                          ads[index].image,
                          // fit: BoxFit.cover,
                          // height: 150,
                          // width: 150,
                        ),
                      ),
                    ),
                    Text(
                      ads[index].url ?? '',
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestoreHelper.instance
                            .deletePopUpAd(ads[index].uid!);
                        await getAllShops();
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    if (!(ads[index].isVisible ?? false))
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestoreHelper.instance
                              .updatePopUpAdVisibility(
                                  ads[index]..isVisible = true);
                          await getAllShops();
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        }),
      ),
    ));

    loading = false;
    update();
  }

  void allOffersDialog(ShopModule shop) async {
    loading = true;
    update();

    final offers = await FirebaseFirestoreHelper.instance
        .getOffers(forAdmin: true)
        .then((value) =>
            value.where((element) => element.shopUID == shop.uid).toList());

    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        height: Get.context!.height * 0.8,
        padding: const EdgeInsets.all(12.0),
        child: Builder(builder: (context) {
          if (offers.isEmpty) {
            return const Center(
              child: Text('لا يوجد عروض'),
            );
          }
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.dialog(PreviewShopDialog(shop: shop));
                      },
                      child: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: NetworkImage(
                          offers[index].imageURL,
                          // fit: BoxFit.cover,
                          // height: 150,
                          // width: 150,
                        ),
                      ),
                    ),
                    Text(
                      offers[index].name,
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestoreHelper.instance
                            .deleteOffer(offers[index]);
                        await getAllShops();
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    if (!(offers[index].isVisible ?? false))
                      IconButton(
                        onPressed: () async {
                          await FirebaseFirestoreHelper.instance
                              .updateOfferVisibility(
                                  offers[index]..isVisible = true);
                          await getAllShops();
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        }),
      ),
    ));

    loading = false;
    update();
  }

  Future<void> getAllPopUpAds() async {
    try {
      final popUpAdsList =
          await FirebaseFirestoreHelper.instance.getPopUpAds(forAdmin: true);
      allPopUpAds = popUpAdsList;
    } catch (e) {
      log(e);
    }
  }

  Future<void> getAllOffers() async {
    try {
      final offersList =
          await FirebaseFirestoreHelper.instance.getOffers(forAdmin: true);
      offers = offersList;
    } catch (e) {
      log(e);
    }
  }

  bool isHasUnVisiblePopUpAds(ShopModule shop) {
    final ads =
        allPopUpAds.where((element) => element.shopUID == shop.uid).toList();
    return ads.any((element) => !(element.isVisible ?? false));
  }

  int noOfUnVisiblePopUpAds(ShopModule shop) {
    final ads =
        allPopUpAds.where((element) => element.shopUID == shop.uid).toList();
    return ads.where((element) => !(element.isVisible ?? false)).length;
  }

  bool isHasUnVisibleOffers(ShopModule shop) {
    final filteredOffers =
        offers.where((element) => element.shopUID == shop.uid).toList();
    return filteredOffers.any((element) => !(element.isVisible ?? false));
  }

  int noOfUnVisibleOffers(ShopModule shop) {
    final filteredOffers =
        offers.where((element) => element.shopUID == shop.uid).toList();
    return filteredOffers
        .where((element) => !(element.isVisible ?? false))
        .length;
  }

  void sortShops() {
    // Shops with unvisible offers and pop up ads will be first
    allShops.sort((a, b) =>
        noOfUnVisibleOffers(b).compareTo(noOfUnVisibleOffers(a)) +
        noOfUnVisiblePopUpAds(b).compareTo(noOfUnVisiblePopUpAds(a)));

    activeShops.sort((a, b) =>
        noOfUnVisibleOffers(b).compareTo(noOfUnVisibleOffers(a)) +
        noOfUnVisiblePopUpAds(b).compareTo(noOfUnVisiblePopUpAds(a)));
  }

  @override
  void onInit() async {
    await getAllShops();

    super.onInit();
  }
}
