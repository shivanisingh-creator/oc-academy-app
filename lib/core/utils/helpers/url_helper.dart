import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class UrlHelper {
  static final Logger _logger = Logger();

  static Future<void> launchUrlString(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _logger.e('Could not launch $urlString');
      }
    } catch (e) {
      _logger.e('Error launching $urlString: $e');
    }
  }
}
