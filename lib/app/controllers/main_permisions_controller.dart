import 'package:get/get.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPermisionsController extends GetxController {
  Permission get photosPerm {
    if (GetPlatform.isAndroid) {
      return Permission.storage;
    } else if (GetPlatform.isIOS) {
      return Permission.photos;
    }
    return Permission.storage;
  }

  void askForPermisions() async {
    if (!await photosPerm.request().isGranted) {
      KSnackBar.error('يجب السماح بالوصول للصور');
      print('Permission not granted');
      if (!await photosPerm.request().isGranted) {
        openAppSettings();
        print('Permission not granted going to app settings');
      }
    }
  }

  @override
  void onInit() {
    askForPermisions();
    super.onInit();
  }
}
