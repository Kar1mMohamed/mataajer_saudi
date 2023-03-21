import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class MainSettingsController extends GetxController {
  List<CategoryModule> mainCategories = [];

  Future<void> getCategories() async {
    try {
      mainCategories = await FirebaseFirestore.instance
          .collection('categories')
          .get()
          .then((value) {
        return value.docs
            .map((e) => CategoryModule.fromMap(e.data(), e.id))
            .toList();
      });

      log('mainCategories: $mainCategories');
    } catch (e) {
      print(e);
    }
  }
}
