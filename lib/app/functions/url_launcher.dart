import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherFuntions {
  URLLauncherFuntions._();

  static Future<void> launchURL(String? url) async {
    // log('URL: $url ,isURL: ${url.isURL}');
    // if (!url.isURL) {
    //   return;
    // }
    // if (!url.contains('http://') || !url.contains('https://')) {
    //   url = 'https://$url';
    // }
    // final uri = Uri.parse(url);

    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri, mode: LaunchMode.externalApplication);
    // } else {
    //   throw 'Could not launch $url';
    // }

    if (url == null) return;

    if (url.isEmpty) {
      return;
    }

    if (!url.contains('http://') || !url.contains('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.parse(url);
    log('launchURL: $url, uri: $uri');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
