// Added by Darshan R on 30/03/2026
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/config/app_config.dart';

class BillService {
  static String get _webBaseUrl => Config.billWebUrl;

  static Future<void> openInBrowser({
    required String customerName,
    required double totalAmount,
    required String orderId,
  }) async {
    try {
      final uri = Uri.parse(_webBaseUrl).replace(queryParameters: {
        'name': customerName,
        'total': totalAmount.toStringAsFixed(2),
        'order': orderId,
        'date': DateTime.now().toIso8601String().split('T')[0],
      });

      // Launch the URL in an external browser
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch $uri");
      }
    } catch (e) {
      print("Browser Launch Error: $e");
    }
  }
}