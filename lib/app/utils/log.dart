import 'dart:developer' as dv;

import 'package:flutter/foundation.dart';

void log(Object message) {
  if (!kDebugMode) return;
  dv.log(message.toString(), name: 'Mataajer');
}
