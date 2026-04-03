// Added by Darshan R on 18/03/2026
import 'package:myapp/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

/// WhatsApp integration service for opening conversations and messaging.
class WhatsAppService {
  static String defaultPhoneNumber = Config.defaultMobileNumber; //  Modified By Yasindu Ganegoda
  static Future<bool> openWhatsApp({
    String? phoneNumber, //  Modified By Yasindu Ganegoda
    String? message,
  }) async {
    try {
   //  Modified By Yasindu Ganegoda
    final targetNumber = phoneNumber ?? defaultPhoneNumber;
    if (targetNumber.isEmpty) {
      return false;
    }
      String url = 'https://wa.me/$targetNumber';
      if (message != null && message.isNotEmpty) {
        url += '?text=${Uri.encodeComponent(message)}';
      }
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
