import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/app/widgets/preview_offer_dialog.dart';
import 'package:mataajer_saudi/app/widgets/shop_animated_widget.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/log.dart';

class AddOfferController extends GetxController {
  bool loading = false;

  bool get isSignedIn => Get.find<MainAccountController>().isSignedIn;

  ShopModule? currentShop;

  String? imageURL;

  final offerName = TextEditingController();
  final offerDescription = TextEditingController();
  final shopLinkController = TextEditingController();
  final offerPercentage = TextEditingController();

  List<OfferModule> offers = [];

  int chooseDuration = 1;

  Future<void> getCurrentShopModule() async {
    try {
      loading = true;
      update();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      currentShop = await FirebaseFirestoreHelper.instance
          .getShopModule(uid, getSubscriptions: true);
    } catch (e) {
      log(e);
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
      Get.back(); // dismiss laoding dialog
    } catch (e) {
      log(e);
    } finally {
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
      if (offerName.text.isEmpty) {
        throw 'يجب ادخال اسم العرض';
      }
      if (offerDescription.text.isEmpty) {
        throw 'يجب ادخال وصف العرض';
      }
      if (offerPercentage.text.isEmpty) {
        throw 'يجب ادخال نسبة الخصم';
      }
      if (chooseDuration == 0) {
        throw 'يجب اختيار مدة العرض';
      }
      loading = true;
      update();

      final module = OfferModule(
        shopUID: FirebaseAuth.instance.currentUser!.uid,
        name: offerName.text,
        shopDescription: currentShop!.description,
        offerDescription: offerDescription.text,
        categoryUIDs: currentShop!.categoriesUIDs,
        imageURL: imageURL!,
        avgShippingPrice: currentShop!.avgShippingPrice,
        avgShippingTime: currentShop!.avgShippingTime,
        offerPercentage: double.tryParse(offerPercentage.text),
        validTill: currentShop!.validTill,
        fromDate: DateTime.now(),
        toDate: DateTime.now().add(Duration(days: chooseDuration)),
        isVisible: true,
        offerLink: shopLinkController.text,
      );

      await FirebaseFirestoreHelper.instance.addOffer(module);
      return true;
    } catch (e) {
      KSnackBar.error(e.toString());
      return false;
      // log(e.toString());
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> getOffers() async {
    try {
      final shopuid = FirebaseAuth.instance.currentUser!.uid;
      loading = true;
      update();
      offers = await FirebaseFirestoreHelper.instance.getShopOffers(shopuid);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> deleteOffer(OfferModule offer) async {
    try {
      loading = true;
      update();
      await FirebaseFirestoreHelper.instance.deletePopUpAd(offer.uid!);
      offers.remove(offer);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  void showOffer(OfferModule offer) {
    Get.dialog(PreviewOfferDialog(offerModule: offer));
  }

  @override
  void onInit() async {
    super.onInit();
    if (isSignedIn) {
      await getCurrentShopModule();
      await getOffers();
    }
  }
}
