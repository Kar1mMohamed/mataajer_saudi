// ignore_for_file: unused_element

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mataajer_saudi/app/data/modules/tap/tap_charge_req.dart';
import 'package:mataajer_saudi/app/helpers/env_helper.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class PaymentsHelper {
  PaymentsHelper._();

  static bool get isDebug => false;
  // TEST
  static String get _debugAuthToken => EnvHelper.instance.PAYMENT_DEVBUG_TOKEN!;
  // TEST
  // static int get _debugProfileId => 93643;

  // LIVE
  static String get _liveAuthToken => EnvHelper.instance.PAYMENT_LIVE_TOKEN!;
  // // LIVE
  // static int get _liveProfileId => 93769;

  // static String get authToken => Sys.isDebug ? _debugAuthToken : _liveAuthToken;
  // static int get profileId => Sys.isDebug ? _debugProfileId : _liveProfileId;

  static String get authToken => _debugAuthToken;
  // _debugAuthToken;

  // static CustomerDetails get staticAddress => CustomerDetails(
  //       name: 'Mohamed Vision',
  //       email: 'info@vision-log.com',
  //       street1: '404, 11th st, void',
  //       city: 'Jaddah',
  //       state: '01',
  //       country: 'SA',
  //     );

  static Future<Map> sendRequest(TapChargeReq module) async {
    String mobileRedirectUrl = 'mataajer://m.mataajer-sa.com/success';

    module.post = Post(url: mobileRedirectUrl);

    module.redirect = Post(url: mobileRedirectUrl);

    module.source = Source(id: 'src_all');

    log('mobileSuccessRedirectUrl: $mobileRedirectUrl');

    // module.mode = 'INVOICE';

    // module.due =
    //     DateTime.now().add(Duration(seconds: 5)).millisecondsSinceEpoch;
    // module.expiry =
    //     DateTime.now().add(Duration(hours: 48)).millisecondsSinceEpoch;
    // module.notifications = null;

    try {
      var headers = {
        'Authorization': 'Bearer $authToken',
        'content-type': 'application/json'
      };
      var request =
          http.Request('POST', Uri.parse('https://api.tap.company/v2/charges'));
      request.body = module.toJson();
      request.headers.addAll(headers);

      var response = await request.send();

      final responseString = await response.stream.bytesToString();
      Map responseMap = json.decode(responseString);

      if (response.statusCode == 200) {
        log('responseMap: $responseMap');
        return responseMap;
      } else {
        log(responseMap);
        throw Exception(response.reasonPhrase ?? 'Error');
      }
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  static Future<bool> checkIFPaid(String id) async {
    try {
      var headers = {'Authorization': 'Bearer $authToken'};
      var request = http.Request(
          'GET', Uri.parse('https://api.tap.company/v2/charges/$id'));

      request.headers.addAll(headers);

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final responseMap = json.decode(responseString);
        log(responseMap);
        final isPaid = responseMap['status'] == 'CAPTURED';
        return isPaid;
      } else {
        return false;
      }
    } catch (e) {
      log(e);
      return false;
    }
  }
}
