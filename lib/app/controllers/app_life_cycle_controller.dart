import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/online_now_controller.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

import '../data/app/life_cycle_enum.dart';

class AppLifeCylceController extends FullLifeCycleController
    with FullLifeCycleMixin {
  Rx<AppLifeCycleEnum> appLifeCyle = AppLifeCycleEnum.Resumed.obs;

  @override
  void onDetached() {
    Get.find<OnlineNowController>().decreaseHit();
    appLifeCyle.value = AppLifeCycleEnum.Detached;
    log('AppLifeCylceController onDetached');
    update();
  }

  @override
  void onInactive() {
    appLifeCyle.value = AppLifeCycleEnum.Inactive;
    log('AppLifeCylceController onInactive');
    update();
  }

  @override
  void onPaused() {
    Get.find<OnlineNowController>().decreaseHit();
    appLifeCyle.value = AppLifeCycleEnum.Paused;
    log('AppLifeCylceController onPaused');
    update();
  }

  @override
  void onResumed() {
    Get.find<OnlineNowController>().addHit();
    appLifeCyle.value = AppLifeCycleEnum.Resumed;
    log('AppLifeCylceController onResumed');
    update();
  }

  @override
  void onInit() {
    super.onInit();
    Get.find<OnlineNowController>().addHit();
  }

  @override
  void onClose() {
    super.onClose();
    Get.find<OnlineNowController>().decreaseHit();
  }

  @override
  InternalFinalCallback<void> get onDelete => InternalFinalCallback(
        callback: () {
          Get.find<OnlineNowController>().decreaseHit();
          log('AppLifeCylceController onDelete');
          update();
        },
      );
}
