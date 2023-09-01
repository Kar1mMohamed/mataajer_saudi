import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';

class CategoryWithOffers {
  CategoryModule category;
  List<OfferModule> offers;

  CategoryWithOffers({
    required this.category,
    required this.offers,
  });
}
