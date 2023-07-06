import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class ShopAccountController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  final mainSettingsController = Get.find<MainSettingsController>();
  ShopModule? currentShop = Get.arguments;
  bool get isShop => mainAccountController.isShopOwner;
  bool loading = false;

  bool isVisible = false;

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

  Future<void> getShop() async {
    if (currentShop != null) return; // if shop is already setted return
    loading = true;
    update();
    try {
      currentShop = await FirebaseFirestoreHelper.instance.getShopModule(
          FirebaseAuth.instance.currentUser!.uid,
          getSubscriptions: true);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

  void setAlreadySetted() {
    shopNameController.text = currentShop?.name ?? '';
    emailController.text = currentShop?.email ?? '';
    shopLinkController.text = currentShop?.shopLink ?? '';
    shopDescriptionController.text = currentShop?.description ?? '';
    shopKeyWordsController.text = currentShop?.keywords?.join(',') ?? '';
    avgShippingPriceController.text =
        currentShop?.avgShippingPrice?.toString() ?? '';
    cuponCodeController.text = currentShop?.cuponCode ?? '';
    cuponCodeDetailsController.text = currentShop?.cuponText ?? '';

    // shippingFrom =
    //     int.parse(currentShop?.avgShippingTime?.split('-')[0].trim() ?? '1');

    // shippingTo =
    //     int.parse(currentShop?.avgShippingTime?.split('-')[1].trim() ?? '1');

    choosedCategories = currentShop?.categories ?? [];
    isVisible = currentShop?.isVisible ?? false;
    update();
  }

  Future<void> updateShop() async {
    loading = true;
    update();
    try {
      final module = currentShop!.copyWith(
        name: shopNameController.text,
        email: emailController.text,
        shopLink: shopLinkController.text,
        description: shopDescriptionController.text,
        keywords: shopKeyWordsController.text.split(','),
        avgShippingPrice: double.parse(avgShippingPriceController.text),
        cuponCode: cuponCodeController.text,
        cuponText: cuponCodeDetailsController.text,
        categoriesUIDs: choosedCategories.map((e) => e.uid!).toList(),
        isVisible: isVisible,
      );

      // if (currentShop!.isVisible != module.isVisible) {
      //   await currentShop!.changeAllAdsVisibility(isVisible);
      // }

      await FirebaseFirestoreHelper.instance.updateShop(module);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
      Get.back();
    }
  }

  Future<void> updateProfileImage() async {
    loading = true;
    update();
    try {
      final photosPerm = Get.find<MainPermisionsController>().photosPerm;
      if (!await photosPerm.request().isGranted) {
        await photosPerm.request();
        KSnackBar.error('يجب السماح بالوصول للصور');
        throw 'Permission not granted';
      }
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) {
        KSnackBar.error('لم يتم اختيار صورة');
        throw 'No image selected';
      }

      currentShop!.image = await FirebaseStorageFunctions.uploadImage(image);
      await FirebaseFirestoreHelper.instance.updateShop(currentShop!);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() async {
    await getShop();
    setAlreadySetted();
    super.onInit();
  }
}
