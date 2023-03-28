import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAdController extends GetxController {
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
        const Center(
          child: CircularProgressIndicator(),
        ),
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

  Future<void> adAdd() async {
    try {
      await pickAndUploadImage();
    } catch (e) {
      print(e);
    }
  }
}
