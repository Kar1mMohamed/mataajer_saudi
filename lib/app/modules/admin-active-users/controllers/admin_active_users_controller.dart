import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';

class AdminActiveUsersController extends GetxController {
  bool loading = false;

  int pageIndex = 0;
  final pageController = PageController();

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

  @override
  void onInit() async {
    await getAllShops();
    super.onInit();
  }
}
