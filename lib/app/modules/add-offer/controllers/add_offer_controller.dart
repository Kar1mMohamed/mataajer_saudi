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

class AddOfferController extends GetxController {
  bool loading = false;

  bool get isSignedIn => Get.find<MainAccountController>().isSignedIn;

  ShopModule? currentShop;

  String? imageURL;

  final shopLinkController = TextEditingController();
  final cuponCodeController = TextEditingController();
  final cuponCodeDescription = TextEditingController();

  Future<void> getCurrentShopModule() async {
    try {
      loading = true;
      update();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      currentShop = await FirebaseFirestoreHelper.instance
          .getShopModule(uid, getSubscriptions: true);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

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
        const ShopAnimatedWidget(),
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

  Future<bool> addOffer() async {
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
        description: cuponCodeDescription.text,
        imageURL: imageURL!,
        avgShippingPrice: currentShop!.avgShippingPrice,
        avgShippingTime: currentShop!.avgShippingTime,
        cuponCode: cuponCodeController.text,
        validTill: currentShop!.validTill,
      );

      await FirebaseFirestoreHelper.instance.addOffer(module);
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
  void onInit() async {
    super.onInit();
    if (isSignedIn) {
      await getCurrentShopModule();
    }
  }
}
