import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherFuntions {
  URLLauncherFuntions._();

  static Future<void> launchURL(String? url) async {
    if (url == null || url.isEmpty) return;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      // do nothing
    } else {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);
    log('launchURL: $url, uri: $uri');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
      // CustomSnackBar.error('Could not launch $url');
    }
  }
}
