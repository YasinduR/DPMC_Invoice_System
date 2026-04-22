import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config{
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
  // API Configuration
  static String get baseUrl => dotenv.get('BASE_URL', fallback: '');
  static String get notificationBackendUrl => dotenv.get('NOTIFICATION_BACKEND_URL', fallback: '');
  static String get defaultMobileNumber => dotenv.get('MOBILE_NUM', fallback: '');
  static String get baseFtp => dotenv.get('FTP_BASE_PATH', fallback: '');
  static String get sftpHost => dotenv.get('SFTP_HOST', fallback: '');
  static String get sftpUsername => dotenv.get('SFTP_USERNAME', fallback: '');
  static String get sftpPassword => dotenv.get('SFTP_PASSWORD', fallback: '');
  static String get baseSftp => dotenv.get('SFTP_BASE_PATH', fallback: '');
  static int get sftpPort => int.tryParse(dotenv.get('SFTP_PORT', fallback: '')) ?? 22;

}