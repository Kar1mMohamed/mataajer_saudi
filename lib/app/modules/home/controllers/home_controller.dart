import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/constants.dart';

class HomeController extends GetxController {
  int categorySelectedIndex = 0;

  void updateCategorySelectedIndex(int index) {
    categorySelectedIndex = index;
    update(['categories']);
  }

  List<String> get categoriesList => ['الكل', ...Constants.categoriesString];
}
