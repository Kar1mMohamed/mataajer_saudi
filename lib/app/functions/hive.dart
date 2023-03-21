import 'package:hive_flutter/hive_flutter.dart';
import 'package:mataajer_saudi/database/shop_fav.dart';

class HiveHelper {
  HiveHelper._();

  static final HiveHelper _instance = HiveHelper._();
  static HiveHelper get instance => _instance;

  static Future<void> initHive() async {
    await Hive.initFlutter();
    _instance.registerAdapters();
    await _instance.openBoxes();
  }

  void registerAdapters() {
    Hive.registerAdapter<ShopFavHive>(ShopFavHiveAdapter());
  }

  Future<void> openBoxes() async {
    await ShopFavHive.openBox;
  }
}
