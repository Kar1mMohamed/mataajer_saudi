import 'package:hive/hive.dart';

part 'shop_fav.g.dart';

@HiveType(typeId: 1)
class ShopFavHive {
  static const String boxName = 'shop_fav';
  static Future<Box<ShopFavHive>> openBox = Hive.openBox<ShopFavHive>(boxName);
  static Box<ShopFavHive> box = Hive.box<ShopFavHive>(boxName);

  @HiveField(0)
  String uid;
  @HiveField(1)
  String name;

  ShopFavHive(this.uid, this.name);
}
