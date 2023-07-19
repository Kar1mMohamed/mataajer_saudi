import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/data/modules/pop_up_ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/app/widgets/shop_animated_widget.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPopupAdController extends GetxController {
  bool loading = false;

  bool get isSignedIn => Get.find<MainAccountController>().isSignedIn;

  ShopModule? currentShop;

  String? imageURL;

  final shopLinkController = TextEditingController();

  List<PopUpAdModule> popUpAds = [];

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
    } catch (e) {
      log(e);
    } finally {
      Get.back(); // dismiss laoding dialog
      update();
    }
  }

  Future<bool> addPopUpAd() async {
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

      final module = PopUpAdModule(
        image: imageURL!,
        shopUID: currentShop!.uid!,
        validTill: currentShop!.validTill,
        url: shopLinkController.text,
        isVisible: false,
        date: DateTime.now(),
      );

      await FirebaseFirestoreHelper.instance.addPopUpAd(module);
      return true;
    } catch (e) {
      // KSnackBar.error(e.toString());
      return false;
      // log(e.toString());
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> getPopUpAds() async {
    try {
      final shopuid = FirebaseAuth.instance.currentUser!.uid;
      loading = true;
      update();
      popUpAds =
          await FirebaseFirestoreHelper.instance.getShopPopUpAds(shopuid);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> deletePopUpAd(PopUpAdModule ad) async {
    try {
      loading = true;
      update();
      await FirebaseFirestoreHelper.instance.deletePopUpAd(ad.uid!);
      popUpAds.remove(ad);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  void showPopUpAd(PopUpAdModule ad) {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Image.network(
              ad.image,
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 10),
            Text(
              ad.url ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'التاريخ: ${ad.date?.toString().split(' ')[0] ?? ''}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void onInit() async {
    super.onInit();
    if (isSignedIn) {
      await getCurrentShopModule();
      await getPopUpAds();
    }
  }
}
