import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class OnlineNowController extends GetxController {
  void addHit() {
    try {
      FirebaseFirestoreHelper.instance.addHit('app', 'online_now');
    } catch (e) {
      log('OnlineNowController addHit: $e');
    }
  }

  void decreaseHit() async {
    try {
      FirebaseFirestoreHelper.instance.addHit('app', 'online_now', toAdd: -1);
    } catch (e) {
      log('OnlineNowController decreaseHit: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> onlineNowStream() =>
      FirebaseFirestore.instance
          .collection('app')
          .doc('online_now')
          .snapshots();
}
