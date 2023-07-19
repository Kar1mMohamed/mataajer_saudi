// import 'dart:convert';
// import 'package:device_info_plus/device_info_plus.dart';

// class DeviceInfoFunctions {
//   DeviceInfoFunctions._();

//   static Future<String> getDeviceInfo() async {
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     final deviceInfo = await deviceInfoPlugin.deviceInfo;
//     final allInfo = deviceInfo.data;
//     return json.encode(allInfo);
//   }

//   static Future<String> getUniqueDeviceToken() async {
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     final deviceInfo = await deviceInfoPlugin.deviceInfo;
//     final allInfo = deviceInfo.data;
//     final token =
//         '${allInfo['product']}/${allInfo['serialNumber']}/${allInfo['manufacturer']}/${allInfo['host']}/${allInfo['model']}/${allInfo['brand']}/${allInfo['device']}';

//     return token;
//   }
// }
