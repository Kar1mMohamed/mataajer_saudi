import 'package:hive_flutter/hive_flutter.dart';
import 'package:mataajer_saudi/database/notification.dart';
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
    Hive.registerAdapter<NotificationModule>(NotificationModuleAdapter());
  }

  Future<void> openBoxes() async {
    await ShopFavHive.openBox;
    await NotificationModule.openBox;
  }
}
