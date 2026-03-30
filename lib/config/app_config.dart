import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config{
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
  // API Configuration
  static String get baseUrl => dotenv.get('BASE_URL', fallback: '');
  static String get defaultMobileNumber => dotenv.get('MOBILE_NUM', fallback: '');

  // E-Bill Configuration
  static String get billWebUrl => dotenv.get('BILL_WEB_URL', fallback: '');
}