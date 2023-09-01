import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/app/category_with_offers.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class AllOffersController extends GetxController {
  bool loading = false;

  List<CategoryWithOffers> categoriesWithOffers = [];

  Future<void> getOffers() async {
    loading = true;
    update();
    try {
      var offers = await FirebaseFirestoreHelper.instance.getOffers();

      for (var offer in offers) {
        var offerCategory = offer.categories.first;
        var categoryWithOffers = categoriesWithOffers.firstWhereOrNull(
            (element) => element.category.uid == offerCategory.uid);
        if (categoryWithOffers == null) {
          categoryWithOffers =
              CategoryWithOffers(category: offerCategory, offers: []);
          categoriesWithOffers.add(categoryWithOffers);
        }

        categoryWithOffers.offers.add(offer);
        return;
      }

      log('offers: ${offers.length}');
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOffers();
  }
}
