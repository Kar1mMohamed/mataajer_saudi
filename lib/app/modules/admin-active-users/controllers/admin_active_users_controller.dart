import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/widgets/loading_image.dart';
import 'package:mataajer_saudi/app/widgets/preview_shop_dialog.dart';

class AdminActiveUsersController extends GetxController {
  RxInt get notificationCount =>
      Get.find<MainNotificationController>().notificationCount;

  bool loading = false;

  int pageIndex = 0;
  final pageController = PageController();
  final searchTextController = TextEditingController();

  List<ShopModule> allShops = [];
  List<ShopModule> activeShops = [];

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

  Future<void> getAllShops() async {
    loading = true;
    updateAllShops();
    try {
      final shopsList = await FirebaseFirestoreHelper.instance.getShops();
      allShops = shopsList;
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      updateAllShops();
    }
  }

  Future<void> getActiveShops() async {
    loading = true;
    updateActiveShops();
    try {
      final shopsList = await FirebaseFirestoreHelper.instance.getShops();
      activeShops = shopsList.where((element) => element.isVisible!).toList();
    } catch (e) {
      print(e);
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
      print(e);
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
      await FirebaseFirestoreHelper.instance.deleteShop(module);
      isCurrentPageAllShops
          ? allShops.remove(module)
          : activeShops.remove(module);
    } catch (e) {
      print(e);
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

    final ads = await FirebaseFirestoreHelper.instance
        .getAds(forAdmin: true)
        .then((value) =>
            value.where((element) => element.shopUID == shop.uid).toList());

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
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListTile(
                title: Text(ads[index].cuponCode ?? ''),
                subtitle: Text(ads[index].description),
                trailing: IconButton(
                  onPressed: () async {
                    await FirebaseFirestoreHelper.instance.deleteAd(ads[index]);
                    await getAllShops();
                    Get.back();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    Get.dialog(PreviewAdDialog(ad: ads[index]));
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
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Image.network(
                    ads[index].image,
                    fit: BoxFit.cover,
                    height: 150,
                    width: 150,
                  ),
                  ListTile(
                    title: Text(
                      ads[index].url ?? '',
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await FirebaseFirestoreHelper.instance
                            .deletePopUpAd(ads[index]);
                        await getAllShops();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
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

  @override
  void onInit() async {
    await getAllShops();
    super.onInit();
  }
}
