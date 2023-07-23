import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/pop_up_ad_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class AdminPopupadsController extends GetxController {
  bool loading = false;
  bool showIsNotActive = false;
  List<PopUpAdModule> popUpAds = [];

  Future<void> getPopUpAds() async {
    try {
      loading = true;
      update();
      popUpAds =
          await FirebaseFirestoreHelper.instance.getPopUpAds(forAdmin: true);
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> cancelFunction(PopUpAdModule ad) async {
    try {
      await FirebaseFirestoreHelper.instance.updatePopUpAd(ad);
    } catch (e) {
      log(e);
    } finally {
      onRefresh();
    }
  }

  Future<void> onRefresh() async {
    loading = true;
    update();
    try {
      await getPopUpAds();
    } catch (e) {
      log('onRefresh: $e');
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPopUpAds();
  }
}
