import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class FirebaseFirestoreHelper {
  FirebaseFirestoreHelper._();

  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper._();

  Future<void> addShop(ShopModule shopModule, String userUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .set(shopModule.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<ShopModule> getShopModule(String uid) async {
    try {
      final profile = await FirebaseFirestore.instance
          .collection('shops')
          .doc(uid)
          .get()
          .then((value) => ShopModule.fromMap(value.data()!, uid));

      final subscriptions = await FirebaseFirestore.instance
          .collection('shops')
          .doc(uid)
          .collection('subscriptions')
          .get()
          .then((value) => value.docs
              .map((e) => SubscribtionModule.fromMap(e.data()))
              .toList());

      profile.subscriptions = subscriptions;

      log('profile: ${profile.toJson()}');

      return profile;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
