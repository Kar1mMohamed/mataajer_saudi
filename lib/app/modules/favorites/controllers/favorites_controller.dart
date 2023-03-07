import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/constants.dart';

class FavoritesController extends GetxController {
  List<String> get categoriesList => ['الكل', ...Constants.categoriesString];
}
