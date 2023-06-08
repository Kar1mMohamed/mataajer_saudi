import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/app/widgets/shop_animated_widget.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAdController extends GetxController {
  bool get isSignedIn => Get.find<MainAccountController>().isSignedIn;

  ShopModule? currentShop;
  bool loading = false;

  String? imageURL;

  final shopLinkController = TextEditingController();

  Future<void> pickAndUploadImage() async {
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
      Get.dialog(
        ShopAnimatedWidget(),
        barrierDismissible: false,
      );
      imageURL = await FirebaseStorageFunctions.uploadImage(image);
    } catch (e) {
      print(e);
    } finally {
      Get.back(); // dismiss laoding dialog
      update();
    }
  }

  Future<void> getCurrentShopModule() async {
    try {
      loading = true;
      update();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      currentShop = await FirebaseFirestoreHelper.instance.getShopModule(uid);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

  Future<bool> adAdd() async {
    try {
      if (imageURL == null) {
        throw 'يجب اختيار صورة';
      }
      if (shopLinkController.text.isEmpty) {
        throw 'يجب ادخال رابط المتجر';
      }
      if (currentShop == null) {
        throw 'يجب تسجيل الدخول';
      }
      loading = true;
      update();
      final module = AdModule(
        shopUID: FirebaseAuth.instance.currentUser!.uid,
        name: currentShop!.name,
        categoryUIDs: currentShop!.categoriesUIDs,
        description: currentShop!.description,
        imageURL: imageURL!,
        avgShippingPrice: currentShop!.avgShippingPrice,
        avgShippingTime: currentShop!.avgShippingTime,
        cuponCode: currentShop!.cuponCode,
      );

      await FirebaseFirestoreHelper.instance.adShopAdd(module);
      return true;
    } catch (e) {
      // KSnackBar.error(e.toString());
      return false;
      // print(e.toString());
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() {
    if (isSignedIn) {
      getCurrentShopModule();
    }
    super.onInit();
  }
}
