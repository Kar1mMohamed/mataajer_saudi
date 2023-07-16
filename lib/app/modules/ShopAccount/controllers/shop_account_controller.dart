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

import '../../../utils/log.dart';

class ShopAccountController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  final mainSettingsController = Get.find<MainSettingsController>();
  ShopModule? currentShop = Get.arguments;
  bool get isShop => mainAccountController.isShopOwner;
  bool loading = false;

  bool isVisible = false;

  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
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

  List<int> shippingTimes = List.generate(30, (index) => index + 1);
  int? shippingFrom;
  int? shippingTo;

  bool showPassword = false;
  bool showCategories = false;

  bool isHasTamara = false;
  bool isHasTabby = false;

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
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  void initilizeDropMenu() {
    shippingFrom = shippingTimes[0];
    shippingTo = shippingTimes[0];
    update();
  }

  void setAlreadySetted() {
    shopNameController.text = currentShop?.name ?? '';
    emailController.text = currentShop?.email ?? '';
    phoneController.text = currentShop?.phone ?? '';
    shopLinkController.text = currentShop?.shopLink ?? '';
    shopDescriptionController.text = currentShop?.description ?? '';
    shopKeyWordsController.text = currentShop?.keywords?.join(',') ?? '';
    avgShippingPriceController.text =
        currentShop?.avgShippingPrice?.toString() ?? '';
    cuponCodeController.text = currentShop?.cuponCode ?? '';
    cuponCodeDetailsController.text = currentShop?.cuponText ?? '';
    avgFromShippingPrice = currentShop?.avgShippingPrice?.toInt() ?? 0;
    avgToShippingPrice = currentShop?.avgShippingPrice?.toInt() ?? 0;
    cuponCodeController.text = currentShop?.cuponCode ?? '';
    cuponCodeDetailsController.text = currentShop?.cuponText ?? '';
    keywords = currentShop?.keywords ?? [];
    isHasTabby = currentShop?.isHasTabby ?? false;
    isHasTamara = currentShop?.isHasTamara ?? false;

    log('shippingFrom: ${currentShop?.avgShippingTime?.split('-')[0].trim() ?? '1'}, shippingTo: ${currentShop?.avgShippingTime?.split('-')[1].trim() ?? '1'}');

    shippingFrom = currentShop?.avgShippingTime != null
        ? int.parse(currentShop!.avgShippingTime!.split('-')[0].trim())
        : null;

    if (shippingFrom == 0) {
      shippingFrom = null;
    }

    shippingTo = currentShop?.avgShippingTime != null
        ? int.parse(currentShop!.avgShippingTime!.split('-')[1].trim())
        : null;

    if (shippingTo == 0) {
      shippingTo = null;
    }

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
        phone: phoneController.text,
        avgShippingTime: '$shippingFrom-$shippingTo',
        token: await FirebaseAuth.instance.currentUser!.getIdToken(),
        isHasTabby: isHasTabby,
        isHasTamara: isHasTamara,
      );

      // if (currentShop!.isVisible != module.isVisible) {
      //   await currentShop!.changeAllAdsVisibility(isVisible);
      // }

      await module.updateValidTill();
      await module.updatePrivileges();
      await FirebaseFirestoreHelper.instance.updateShop(module);
    } catch (e) {
      log(e);
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
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() async {
    await getShop();
    initilizeDropMenu();
    setAlreadySetted();
    super.onInit();
  }
}
