import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class AdminOffersController extends GetxController {
  bool loading = false;

  List<OfferModule> _offers = [];
  List<OfferModule> offers = [];

  Future<void> getOffers() async {
    loading = true;
    update();
    try {
      _offers =
          await FirebaseFirestoreHelper.instance.getOffers(forAdmin: true);

      offers = _offers;
    } catch (e) {
      log('getOffers: $e');
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> deleteOffer(OfferModule offer) async {
    try {
      await FirebaseFirestoreHelper.instance.deleteOffer(offer);
    } catch (e) {
      log('deleteOffer: $e');
    }
  }

  void updateOfferCard(int index) {
    update(['offer-card-$index']);
  }

  void search(String query) {
    if (query.isEmpty) {
      offers = _offers;
    } else {
      offers = _offers
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()) ||
              (element.offerPercentage ?? 0)
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await getOffers();
  }
}
