import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/app/category_with_offers.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class AllOffersController extends GetxController {
  RxBool loading = false.obs;

  RxList<CategoryWithOffers> categoriesWithOffers = <CategoryWithOffers>[].obs;

  List<OfferModule> dumpOffers(OfferModule offerModule) {
    var mainCategories = Get.find<MainSettingsController>().mainCategories;
    var offers = <OfferModule>[];
    for (var mainCategory in mainCategories) {
      var newOffer = offerModule.copyWith(
        categoryUIDs: [mainCategory.uid!],
      );
      offers.add(newOffer);
    }

    return offers;
  }

  Future<void> getOffers() async {
    loading.value = true;
    update();
    try {
      var offers = await FirebaseFirestoreHelper.instance.getOffers();

      var preparedOffers = await prepare(offers);

      var dump = dumpOffers(OfferModule(
        name: 'ساعة يد',
        categoryUIDs: ['ساعات'],
        imageURL:
            'https://images-na.ssl-images-amazon.com/images/I/71Swqqe7XAL._AC_SX466_.jpg',
      ));

      // preparedOffers.addAll(await prepare(dump));

      categoriesWithOffers.addAll(preparedOffers);

      log('offers: ${preparedOffers.length}');
    } catch (e) {
      log(e);
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<List<CategoryWithOffers>> prepare(List<OfferModule> offers) async {
    var preparedOffers = <CategoryWithOffers>[];

    for (var offer in offers) {
      try {
        var offerCategory = offer.categories.first;
        var categoryWithOffers = preparedOffers.firstWhereOrNull(
            (element) => element.category.uid == offerCategory.uid);
        if (categoryWithOffers == null) {
          categoryWithOffers =
              CategoryWithOffers(category: offerCategory, offers: []);
          preparedOffers.add(categoryWithOffers);
        }

        categoryWithOffers.offers.add(offer);
      } catch (e) {
        log(e.toString());
        continue;
      }
    }

    return preparedOffers;
  }

  @override
  void onInit() {
    super.onInit();
    getOffers();
  }
}
