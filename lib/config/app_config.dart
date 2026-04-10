import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config{
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
  // API Configuration
  static String get baseUrl => dotenv.get('BASE_URL', fallback: '');
  static String get notificationBackendUrl => dotenv.get('NOTIFICATION_BACKEND_URL', fallback: 'https://dpmc-notification-backend.vercel.app');
  static String get defaultMobileNumber => dotenv.get('MOBILE_NUM', fallback: '');
  static String get baseFtp => dotenv.get('FTP_BASE_PATH', fallback: '');

}