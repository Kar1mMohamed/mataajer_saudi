import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class ShopLoginAndRegisterController extends GetxController {
  final pageController = PageController();
  int pageIndex = 0;

  bool showCategories = false;

  List<String> subTitles = ['تسجيل دخول', 'تسجيل اشتراك'];

  bool showPassword = false;

  String? shopImageURL;
  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final shopLinkController = TextEditingController();
  List<String> choosedCategories = [];
  final shopDescriptionController = TextEditingController();
  List<String> keywords = [];
  int avgFromShippingPrice = 0;
  int avgToShippingPrice = 0;
  final avgShippingPriceController = TextEditingController();
  final cuponCodeController = TextEditingController();

  int? shippingFrom;
  int? shippingTo;

  void pickImageAndUpload() async {
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
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      final url = await FirebaseStorageFunctions.uploadImage(image);
      shopImageURL = url;
      Get.back(); // dismiss laoding dialog
      KSnackBar.success('تم رفع الصورة بنجاح');
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }

  void changePageIndex(int index) {
    pageIndex = index;
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    update();
    update(['subTitle']);
  }

  void updateShowCategories() {
    showCategories = !showCategories;
    update(['showCategories']);
  }
}
