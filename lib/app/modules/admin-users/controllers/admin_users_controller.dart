import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/constants.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_auth.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

class AdminUsersController extends GetxController {
  final mainSettingsController = Get.find<MainSettingsController>();

  bool loading = false;

  final List<ShopModule> _shops = [];
  List<ShopModule> shops = [];

  final phoneController = TextEditingController();
  String? shopImageURL;
  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final shopLinkController = TextEditingController();
  List<CategoryModule> choosedCategories = [];
  final shopDescriptionController = TextEditingController();
  final shopKeyWordsController = TextEditingController();
  List<String> keywords = [];

  final avgShippingPriceController = TextEditingController();
  final cuponCodeController = TextEditingController();
  final cuponCodeDetailsController = TextEditingController();

  bool showPassword = false;
  List<CategoryModule> get categoriesList =>
      mainSettingsController.mainCategories;

  int? shippingFrom;
  int? shippingTo;

  bool showCategories = false;

  void updateShopCard(int index) {
    update(['shop-card-$index']);
  }

  void updateShowCategories() {
    showCategories = !showCategories;
    update(['showCategories']);
  }

  Future<void> getShops() async {
    _shops.clear();
    loading = true;
    update();
    try {
      final shops =
          await FirebaseFirestoreHelper.instance.getShops(forAdmin: true);

      _shops.addAll(shops);
    } catch (e) {
      log(e);
    } finally {
      shops = _shops;
      loading = false;
      update();
    }
  }

  Future<void> deleteShop(ShopModule shop) async {
    try {
      await FirebaseAuthFuntions.deleteUsersWithoutLogin(token: shop.token);
      await FirebaseFirestoreHelper.instance.deleteShop(shop);
    } catch (e) {
      log('Error while deleting user: $e');
    }
  }

  Future<void> register(ChooseSubscriptionModule sub) async {
    try {
      if (choosedCategories.isEmpty) {
        throw 'No categories selected';
      }

      loading = true;
      updateAdShopDialog();

      final regResponse = await FirebaseAuthFuntions.createUserWithoutLogin(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (regResponse == null) {
        throw 'Error while registering';
      }

      final registerFirebaseApp = regResponse.app;

      if (registerFirebaseApp == null) {
        throw 'Error while registering';
      }

      final userCredential = regResponse.userCredential;

      if (userCredential == null) {
        throw 'Error while registering';
      }

      await userCredential.user!.sendEmailVerification();

      final shopModule = ShopModule(
        name: shopNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        description: shopDescriptionController.text,
        image: Constants.unKnownPersonImageURL,
        avgShippingPrice: double.parse(avgShippingPriceController.text),
        avgShippingTime: '${shippingFrom!}-${shippingTo!}',
        cuponCode: cuponCodeController.text,
        cuponText: cuponCodeDetailsController.text,
        categoriesUIDs: choosedCategories.map((e) => e.uid!).toList(),
        keywords: shopKeyWordsController.text.split(','),
        shopLink: shopLinkController.text,
        token: await userCredential.user!.getIdToken(),
      );

      registerFirebaseApp.delete(); // Delete temporary firebase app

      await FirebaseFirestoreHelper.instance
          .addShop(shopModule, userCredential.user!.uid);

      final subscriptionModule = SubscriptionModule(
        from: DateTime.now(),
        to: DateTime.now().add(Duration(days: sub.allowedDays!)),
        subscriptionSettingUID: sub.uid!,
      );

      await FirebaseFirestoreHelper.instance
          .addSubscription(userCredential.user!.uid, subscriptionModule);

      final finalShopModule = await FirebaseFirestoreHelper.instance
          .getShopModule(userCredential.user!.uid);

      await finalShopModule.updateValidTill();
      await finalShopModule.updatePrivileges();

      KSnackBar.success('تم اضافة المتجر بنجاح');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // log('The password provided is too weak.');
        throw 'كلمة المرور ضعيفة';
      } else if (e.code == 'email-already-in-use') {
        // log('The account already exists for that email.');
        throw 'البريد الالكتروني مستخدم من قبل';
      }
    } catch (e) {
      log('Error while registering: $e');
      KSnackBar.error(e.toString().tr);
    } finally {
      clearAll();
      Get.back(); // to close dialog
      loading = false;
      updateAdShopDialog();
    }
  }

  void updateAdShopDialog() {
    update(['add-shop-dialog']);
  }

  void search(String query) {
    log('query: $query');

    if (query.isEmpty || query == '') {
      shops = _shops;
      return;
    }

    shops = _shops
        .where((element) =>
            element.name.contains(query) ||
            (element.phone ?? '').contains(query) ||
            (element.email ?? '').contains(query))
        .toList();

    update();
  }

  void clearAll() {
    shopImageURL = null;
    shopNameController.clear();
    emailController.clear();
    passwordController.clear();
    shopLinkController.clear();
    choosedCategories.clear();
    shopDescriptionController.clear();
    shopKeyWordsController.clear();
    keywords.clear();
    avgShippingPriceController.clear();
    cuponCodeController.clear();
    cuponCodeDetailsController.clear();
    phoneController.clear();
    shippingFrom = null;
    shippingTo = null;
  }

  @override
  void onInit() async {
    super.onInit();
    await getShops();
  }
}
