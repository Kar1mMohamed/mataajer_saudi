// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  EnvHelper._();
  static final EnvHelper _instance = EnvHelper._();
  static EnvHelper get instance => _instance;

  String? get PAYMENT_DEVBUG_TOKEN => dotenv.env['PAYMENT_DEVBUG_TOKEN'];
  String? get PAYMENT_LIVE_TOKEN => dotenv.env['PAYMENT_LIVE_TOKEN'];
}
