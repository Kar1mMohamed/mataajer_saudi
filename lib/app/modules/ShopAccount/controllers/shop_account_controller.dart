import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';

class ShopAccountController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  final mainSettingsController = Get.find<MainSettingsController>();
  bool get isShop => mainAccountController.isShopOwner;
  bool loading = false;

  bool showShop = false;

  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final shopLinkController = TextEditingController();
  List<CategoryModule> choosedCategories = [];
  final shopDescriptionController = TextEditingController();
  final shopKeyWordsController = TextEditingController();
  List<String> keywords = [];
  int avgFromShippingPrice = 0;
  int avgToShippingPrice = 0;
  final avgShippingPriceController = TextEditingController();
  final cuponCodeController = TextEditingController();
  final cuponCodeDetailsController = TextEditingController();

  int? shippingFrom;
  int? shippingTo;

  bool showPassword = false;
  bool showCategories = false;

  void updateShowCategories() {
    showCategories = !showCategories;
    update(['showCategories']);
  }

  List<CategoryModule> get categoriesList =>
      mainSettingsController.mainCategories;
}
