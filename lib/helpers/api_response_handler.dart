// Remove with Mock-api

T parseApiResponse<T>(
  Map<String, dynamic> json,
  T Function(dynamic) parseData,
) {
  final bool success = json['success'] ?? false;
  final String message = json['message'] ?? 'Unknown error';

  if (!success) {
    throw Exception('API Error: $message');
  }

  final dynamic rawData = json['data'];
  if (rawData == null) {
    throw Exception('API Error: No data found');
  }

  return parseData(rawData);
}
