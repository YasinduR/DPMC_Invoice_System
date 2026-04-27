import 'dart:io';

import 'package:myapp/services/log_text_service.dart';

class ApiLogger {
  static String? _apiLogFolderPath;

  static Future<void> _ensureFolder() async {
    if (_apiLogFolderPath != null) return;

    final basePath = LogTextService.dpmcFolderPath;
    if (basePath == null) return;

    final folder = Directory('$basePath/api_log');

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    _apiLogFolderPath = folder.path;
  }

  static String _timestamp() => DateTime.now().toIso8601String();

  static String _fileName() =>
      'api_${DateTime.now().millisecondsSinceEpoch}.txt';

  /// 🔹 Create log file with request
  static Future<File?> logRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      await _ensureFolder();
      if (_apiLogFolderPath == null) return null;

      final file = File('$_apiLogFolderPath/${_fileName()}');

      final content = '''
================ API CALL ================
TIME: ${_timestamp()}

URL:
$url

REQUEST BODY:
$body

''';

      await file.writeAsString(content);
      return file; // ✅ return file reference
    } catch (_) {
      return null;
    }
  }

  /// 🔹 Append response to same file
  static Future<void> logResponse({
    required File? file,
    required int statusCode,
    required String response,
  }) async {
    try {
      if (file == null) return;

      final content = '''
RESPONSE STATUS:
$statusCode

RESPONSE BODY:
$response

========================================

''';

      await file.writeAsString(content, mode: FileMode.append);
    } catch (_) {}
  }
}