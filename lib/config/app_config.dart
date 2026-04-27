import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config{
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
  // API Configuration
  static String get baseUrl => dotenv.get('BASE_URL', fallback: '');
  static String get baseApiTestUrl => dotenv.get('BACKEND_URL', fallback: '');  // keep only one base url after completion
  static String get notificationBackendUrl => dotenv.get('NOTIFICATION_BACKEND_URL', fallback: '');
  static String get defaultMobileNumber => dotenv.get('MOBILE_NUM', fallback: '');
  static String get baseFtp => dotenv.get('FTP_BASE_PATH', fallback: '');

}