import 'package:get/get.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherFuntions {
  URLLauncherFuntions._();

  static Future<void> launchURL(String url) async {
    log('isURL: ${url.isURL}');
    if (!url.isURL) {
      return;
    }
    if (!url.contains('http://') || !url.contains('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
