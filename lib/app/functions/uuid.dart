import 'package:uuid/uuid.dart';

class UUIDFunctions {
  UUIDFunctions._();

  static String getDeviceUUID() {
    Uuid uuid = const Uuid();

    return uuid.v5(Uuid.NAMESPACE_X500, 'mataajer_saudi');
  }
}
