import 'dart:math';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class UUIDFunctions {
  UUIDFunctions._();

  static String getDeviceUUID() {
    Uuid uuid = const Uuid();
    var randomBytes = <int>[];
    for (var i = 0; i < 124; i++) {
      randomBytes.add(Random().nextInt(255));
    }

    return uuid.v8(config: V8Options(DateTime.now(), randomBytes));
  }
}
